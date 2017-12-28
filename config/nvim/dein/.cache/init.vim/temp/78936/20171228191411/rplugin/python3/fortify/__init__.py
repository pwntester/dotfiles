# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import neovim
import time
import os
import os.path
import xml.etree.ElementTree as etree
import subprocess
import zipfile
import re
import inspect
import json
import requests
import importlib
import shutil
import ntpath
import codecs
import tempfile
import threading
import uuid
import webbrowser
from whoosh.index import create_in
from whoosh.fields import Schema, TEXT
from whoosh import qparser
from io import StringIO
from distutils.version import StrictVersion
from fortify.indenter import Indenter
from fortify.ruletesting import TranslateFileCommand, TranslateProjectCommand, ScanCommand
from fortify.completer import RuleCompleter

@neovim.plugin
class Fortify:
    rule_id_pattern = re.compile('(\s*)<RuleID>.*</RuleID>\s*')
    rule_start_pattern = re.compile(r'<[A-Za-z]*Rule[\s>]')
    rule_end_pattern = re.compile("</[A-Za-z]*Rule>")
    commented_rule_start_pattern = re.compile(r'<!--[A-Za-z]*Rule[\s>]')
    commented_rule_end_pattern = re.compile("</[A-Za-z]*Rule-->")

    def __init__(self, vim):
        self.vim = vim

    def get_rule_id(self):
        return str(uuid.uuid4()).upper()

    def get_rule(self, start_re=rule_start_pattern, end_re=rule_end_pattern, silent=False):
        start = None
        end = None
        b = self.vim.current.buffer
        current_line = int(self.vim.current.window.cursor[0])
        for i in range(current_line-1,max(current_line-100,0),-1):
            m = start_re.search(b[i])
            if m:
                start = m.start(0)
                break
        if start is None or i < min(current_line-100,0) + 1:
            if not silent:
                self.status_message('Not in rule region (error 1)')
            return None, None, None
        for j in range(i+1,min(len(b),i+100)):
            m = end_re.search(b[j])
            if m:
                end = m.end(0)
                break
        if end is None or j < current_line - 1 or j == len(b) or j > i+100:
            if not silent:
                self.status_message("Not in rule region (error 1)")
            return None, None, None
        count = 0
        for l,k in enumerate(b[i:j+1]):
            if l==0:
                count += len(k[start:])
            elif l==len(b[i:j+1])-1:
                count += len(k[:end])
            else:
                count += len(k)
        if count > 0:
            return b[i:j+1], (i+1,start+1), (j+1,end+1)
        if not silent:
            self.status_message("Could not find rule")
        return None, None, None

    def select_rule_block(self):
        rule, start, end  = self.get_rule()
        if rule is None:
            return None, None, None
        self.vim.command('cal cursor(%d, %d)' % (start[0], 1))
        self.vim.command('normal V')
        self.vim.command('cal cursor(%d, %d)' % (end[0], end[1],))
        return rule, start, end

    ######################
    #      NewRuleID     #
    ######################
    @neovim.command('NewRuleID', range='', nargs='*', sync=True)
    def new_rule_id(self, args, range):
        b = self.vim.current.buffer
        current_pos = self.vim.current.window.cursor
        rule, start, end  = self.get_rule()
        if not rule:
            self.status_message("You need to be in a rule to generate a new rule ID")
            return
        for i, line in enumerate(b[start[0]:end[0]]):
            if self.rule_id_pattern.match(line):
                new_line = self.rule_id_pattern.sub(r'\1<RuleID>%s</RuleID>' % self.get_rule_id(), line)
                self.vim.command('cal cursor(%d, %d)' % (start[0]+i+1,end[0]))
                self.vim.command('normal dd')
                self.vim.current.buffer.append(new_line,start[0]+i)
        self.vim.command('cal cursor(%d, %d)' % (current_pos[0], current_pos[1],))

    ######################
    #      CloneRule    #
    ######################
    @neovim.command('CloneRule', range='', nargs='*', sync=True)
    def clone_rule(self, args, range):
        rule, start, end  = self.get_rule()
        rule[0] = ' '*(start[1]-1) + rule[0][start[1]-1:]
        rule[len(rule)-1] = rule[len(rule)-1][:end[1]-1]
        for i, line in enumerate(rule):
            if self.rule_id_pattern.match(line):
                rule[i] = self.rule_id_pattern.sub(r'\1<RuleID>%s</RuleID>' % self.get_rule_id(), line)
        self.vim.current.buffer.append(rule,end[0])
        self.vim.command('cal cursor(%d, %d)' % (1+2*end[0]-start[0],start[0]))

    ######################
    #      IndentRule    #
    ######################
    @neovim.command('IndentRule', range='', nargs='*', sync=True)
    def indent_rule(self, args, range):
        if len(args) == 0:
            mode = self.vim.eval('g:fortify_DefaultIndentation')
        elif len(args) == 1:
            mode = args[0]
        else:
            self.status_message("Error: Too many arguments. Usage: IndentRule (structural)")
            return

        if mode == "structural":
            indent_structural = True
        else:
            indent_structural = False
        b = self.vim.current.buffer
        current_pos = self.vim.current.window.cursor
        rule, start, end  = self.select_rule_block()
        indented_rule = Indenter().indentxml("\n".join(rule), indent_structural)
        self.vim.command("normal x")
        new_rule = indented_rule.split("\n")
        for i, line in enumerate(new_rule):
            new_rule[i] = " " * (start[1]-1) + line
        self.vim.current.buffer.append(new_rule, start[0]-1)
        self.vim.command('cal cursor(%d, %d)' % (current_pos[0], current_pos[1],))

    ######################
    #  ApplyTransformer  #
    ######################
    @neovim.command('ApplyTransformer', range='', nargs='*', sync=True)
    def apply_transformer(self, args, range):
        if len(args) == 0:
            transformer = None
        elif len(args) == 1:
            transformer = args[0]
        else:
            self.status_message("Error: Too many arguments. Usage: ApplyTransformer [<transformer>]")
            return

        module = importlib.import_module('fortify.transformers')
        if not transformer:
            classes = [(i, member[1].name(), member[1].description()) for i, member in enumerate(inspect.getmembers(module)) if inspect.isclass(member[1])]
            menu = ["  %d - %s: %s" % (i, name, description) for i, name, description in classes if name != "" and description != ""]
            menu.insert(0, "Select transformer:")
            c = self.vim.eval("inputlist(%s)" % str(menu))
            transformer = classes[int(c)][1]
        rule, start, end = self.get_rule()
        if rule:
            rule = "\n".join(rule)
            t = None
            try:
                tclass = getattr(module, transformer)
                t = tclass()
            except:
                print("Could not instantiate transformer: %s" % transformer)
            if t is not None:
                rules = t.run(rule)
                if rules is not None:
                    output = ""
                    for rule in rules:
                        indented_rule = Indenter().indentxml(rule)
                        for i, line in enumerate(indented_rule.split('\n')):
                            output += " " * (start[1]-1) + line + "\n"
                    output = output.replace('    ]]></Definition>', ']]></Definition>')
                    output = output.strip('\n')
                    # Select and remove original rule
                    self.select_rule_block()
                    self.vim.command('normal x')
                    # Insert new rules
                    self.vim.current.buffer.append(output.split('\n'),start[0]-1)
                    # Select inserted new text
                    # self.vim.command('cal cursor(%d, %d)' % (start[0],1))
                    # self.vim.command('normal v')
                    # self.vim.command('cal cursor(%d, %d)' % (start[0]+len(output.split('\n'))-1,1))

    ########################
    #  PasteWithNewRuleID  #
    ########################
    @neovim.command('PasteWithNewRuleID', range='', nargs='*', sync=False)
    def paste_with_new_rule_id(self, args, range):
        content = self.vim.eval('@"')
        content = content[:content.rfind('\n')]
        current_pos = self.vim.current.window.cursor
        new_content = re.sub(r'<RuleID>.*</RuleID>', r'<RuleID>%s</RuleID>' % self.get_rule_id(), content)
        self.vim.current.buffer.append(new_content.split('\n'), current_pos[0])

    ######################
    #     CommentRule    #
    ######################
    @neovim.command('CommentRule', range='', nargs='*', sync=True)
    def comment_rule(self, args, range):
        b = self.vim.current.buffer
        current_pos = self.vim.current.window.cursor
        is_commented = False
        rule, start, end  = self.get_rule()
        if not rule:
            is_commented = True
            rule, start, end  = self.get_rule(start_re=self.commented_rule_start_pattern, end_re=self.commented_rule_end_pattern)
        if not rule:
            self.status_message("Not in rule")
            return
        if not is_commented:
            rule[0] = re.sub(r'^(\s*)<', '\g<1><!--', rule[0])
            rule[-1] = re.sub(r'>(\s*)$', '-->\g<1>', rule[-1])
        else:
            rule[0] = re.sub(r'^(\s*)<!--', '\g<1><', rule[0])
            rule[-1] = re.sub(r'-->(\s*)$', '>\g<1>', rule[-1])
        self.vim.command('cal cursor(%d, %d)' % (start[0],0))
        self.vim.command('normal dd')
        self.vim.current.buffer.append(rule[0], start[0]-1)
        self.vim.command('cal cursor(%d, %d)' % (end[0],0))
        self.vim.command('normal dd')
        self.vim.current.buffer.append(rule[-1], end[0]-1)
        self.vim.command('cal cursor(%d, %d)' % (current_pos[0], current_pos[1],))

    ######################
    #    PatternValue    #
    ######################
    @neovim.command('PatternValue', range='', nargs='*', sync=True)
    def pattern_value(self, args, range):
        line = self.vim.current.line
        current_pos = self.vim.current.window.cursor
        if re.match(r'\s*<Pattern>.*</Pattern>\s*', line):
            new_line = re.sub(r'(\s*)<Pattern>(.*)</Pattern>(\s*)', r'\1<Value>\2</Value>\3', line)
        elif re.match(r'\s*<Value>.*</Value>\s*', line):
            new_line = re.sub(r'(\s*)<Value>(.*)</Value>(\s*)', r'\1<Pattern>\2</Pattern>\3', line)
        self.vim.command('normal dd')
        self.vim.current.buffer.append(new_line, self.vim.eval('line(".") - 1'))
        self.vim.command('cal cursor(%s, %s)' % (current_pos[0], current_pos[1],))

    ######################
    #      AuditPane     #
    ######################
    @neovim.command('AuditPane', range='', nargs='*', sync=True)
    def audit_pane(self, args, range):
        self.vim.command('let auditpanewinnr = bufwinnr("__AuditPane__")')
        if self.vim.eval('auditpanewinnr') != -1:
            self.vim.command("call fortify#CloseAuditPaneWindow()")
        else:
            self.vim.command("call fortify#OpenAuditPaneWindow()")

    ######################
    #   ViewCategoryRow  #
    ######################
    @neovim.command('ViewCategoryRow', range='', nargs='*', sync=True)
    def view_category_row(self, args, range):
        current_line = self.vim.current.line
        fields = self.vim.current.buffer[0].split(',')
        matches = re.findall(r'\"(.+?)\"', current_line)
        for m in matches:
            current_line = current_line.replace(m, m.replace(',', '&comma;'))
        current_line = current_line.replace('"', '\"')
        values = current_line.split(',')
        lines = [name + ": " + value.replace('&comma;', ',') for name,value in zip(fields, values)]
        text = '\n'.join(lines).replace('Standards Mapping - ','')
        self.vim.command('enew')
        self.vim.command('set ft=fortifycategory')
        self.vim.command('setlocal buftype=nofile')
        self.vim.command('setlocal bufhidden=hide')
        self.vim.command('setlocal noswapfile')
        self.vim.command('map <buffer> q :bd<CR>')
        self.vim.command('setlocal nobuflisted')
        self.vim.command('setlocal noreadonly')
        self.vim.command('setlocal ff=unix')
        self.vim.command('setlocal nolist')
        self.vim.current.buffer.append(text.split('\n'))

    #######################
    # GenerateCategoryRow #
    #######################
    @neovim.command('GenerateCategoryRow', range='', nargs='*', sync=True)
    def generate_category_row(self, args, range):
        values = [line.split(': ')[1] for line in self.vim.current.buffer if line != ""]
        line = ','.join(values)
        self.vim.command("call setreg('0', '%s')" % line)
        self.status_message("New Category is ready in register 0")

    #####################
    #    NewRulePack    #
    #####################
    @neovim.command('NewRulePack', range='', nargs='*', sync=True)
    def new_rulepack(self, args, range):
        if len(args) == 0:
            self.status_message("Error, not enough arguments")
            return
        elif len(args) == 1:
            filename = args[0]
        elif len(args) > 1:
            self.status_message("Error, too many arguments")
            return

        template = """<?xml version="1.0" encoding="UTF-8"?>
<RulePack xmlns="xmlns://www.fortifysoftware.com/schema/rules" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="RulePack">
    <RulePackID>UUID1</RulePackID>
    <SKU>SKU-UUID2</SKU>
    <Name><![CDATA[]]></Name>
    <Version>1.0</Version>
    <Description><![CDATA[]]></Description>
    <Rules version="3.2">
        <RuleDefinitions>
            
        </RuleDefinitions>
    </Rules>
</RulePack>"""
        template = template.replace('UUID1', self.get_rule_id())
        template = template.replace('UUID2', self.get_rule_id())
        self.vim.command('enew')
        self.vim.command('set ft=fortifyrulepack')
        self.vim.current.buffer.append(str(template).split("\n"), 0)
        self.vim.command('cal cursor(10, 14)')
        self.vim.command('w! %s' % filename)

    ######################
    #       ShowNST      #
    ######################
    @neovim.command('ShowNST', range='', nargs='*', sync=True)
    def show_nst(self, args, range):
        self.vim.command("let g:fortify_currentpath = resolve(expand('%:p'))")
        current_path = self.vim.eval("g:fortify_currentpath")
        paths = self.get_possible_paths(current_path)
        if paths and len(paths) > 0:
            if len(paths) > 1:
                menu = ['  %d - %s' % (i,str(p)) for i,p in enumerate(paths)]
                menu.insert(0, "Select NST:")
                c = self.vim.eval("inputlist(%s)" % str(menu))
                self.vim.command("e %s" % paths[int(c)])
            else:
                self.vim.command("e %s" % paths[0].replace(' ', '\ '))
            self.vim.command('set ft=fortifynst')
            self.vim.command('map <buffer> q :bd<CR>')
        else:
           self.status_message("Cannot find the NST, sorry :(")

    def get_possible_paths(self, ffile):
        if ffile is None or ffile == "":
            return None
        nsts = []
        home = self.vim.eval('g:fortify_NSTRoot')
        if home == "":
            home = os.path.expanduser("~")
        NSTRoot = os.path.join(home, '.fortify')
        version = self.get_SCA_version()
        if version is not None:
            if StrictVersion(version) > StrictVersion("6.01"):
                version = version[0:-1]
            NSTRoot = os.path.join(NSTRoot, "sca" + version, "build")
            for root, dirs, files in os.walk(NSTRoot):
                for d in dirs:
                    path = NSTRoot + "/" + d + ffile + ".nst"
                    if os.path.isfile(path):
                        nsts.append(path)
            return list(set(nsts))
        return None

    def get_SCA_version(self, short=True):
        version = subprocess.Popen(["sourceanalyzer", "-v"], shell=False, stdout=subprocess.PIPE).stdout.read()
        version = version.decode('unicode_escape')
        if not short:
            return version
        version = re.findall(".*Analyzer\s+(\d+\.\d+)\.\d+.*", version)
        if version != None and len(version) > 0:
            version = version[0]
        else:
            version = None
        return version

    ######################
    #   SwiftMigrator    #
    ######################
    @neovim.command('SwiftMigrator', range='', nargs='*', sync=False)
    def swift_migrator(self, args, range):
        import fortify.swiftmigrator
        rule, start, end  = self.get_rule()
        rule = "\n".join(rule)
        prefix = '<?xml version="1.0" encoding="UTF-8"?>\n<RulePack xmlns="xmlns://www.fortifysoftware.com/schema/rules" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="RulePack">'
        suffix = '</RulePack>'
        fp = tempfile.NamedTemporaryFile(delete=False, suffix=".xml")
        fp.write(prefix + rule + suffix)
        fp.close()
        cmd = "python swiftmigrator.py %s" % fp.name
        process = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        (output, err) = process.communicate()
        exitcode = process.returncode
        winnr = int(self.vim.eval("bufwinnr('__SwiftMigrator__')"))
        if winnr is not None and winnr != -1:
            self.vim.command('%s wincmd w' % winnr)
            self.vim.command('normal! ggdG')
        else:
            self.vim.command('silent keepalt botright vsplit __SwiftMigrator__')
        self.vim.current.buffer.append(output.splitlines())
        self.vim.current.buffer.append("")
        self.vim.current.buffer.append(err.splitlines())

    ######################
    #       OpenFPR      #
    ######################
    @neovim.command('OpenFPR', range='', nargs='*', sync=False)
    def open_fpr(self, args, range):
        fpr_path = self.vim.eval("g:fortify_fprpath")
        command = ["auditworkbench"] + self.vim.eval('g:fortify_AWBOpts') + [fpr_path]
        subprocess.Popen(command, shell=False)

    ######################
    #       LoadFPR      #
    ######################
    @neovim.command('LoadFPR', range='', nargs='*', sync=False)
    def load_fpr(self, args, range):
        if len(args) == 0:
            self.status_message("Error, not enough arguments")
            return
        elif len(args) == 1:
            fpr_path = args[0]
        elif len(args) > 1:
            self.status_message("Error, too many arguments")
            return

        if os.path.isfile(fpr_path):
            data = self.get_scan_issues(fpr_path)
            self.vim.command('let g:fortify#scaninfo = %s' % data)
        else:
            self.vim.command("FPR does not exist'")
            return

        self.vim.command("let g:fortify#scaninfo_orig = deepcopy(g:fortify#scaninfo)")

        # Display the auditpane content
        self.vim.command("call fortify#OpenAuditPaneWindow()")
        if self.vim.eval("bufwinnr('__AuditPane__') != -1"):
            self.vim.command("call fortify#RenderContent()")

    def get_scan_issues(self, fpr_path):

        tmpdir = os.path.join(tempfile.gettempdir(), str(uuid.uuid4()))
        zip = zipfile.ZipFile(fpr_path)
        zip.extract('audit.fvdl', tmpdir)

        # Remove anything after UnifiedNodePool to speedup parsing
        fvdl = os.path.join(tmpdir, 'audit.fvdl')
        content = open(fvdl, 'r').read()

        idx = content.find('<Description')
        if idx > -1:
            tree = etree.parse(StringIO(content[:idx] + '</FVDL>'))
        else:
            tree = etree.parse(StringIO(content))

        ruleinfo_elements = None
        idx1 = content.find('<RuleInfo>')
        idx2 = content.find('</RuleInfo>') + len('</RuleInfo>')
        if idx1 > -1 and idx2 > -1:
            ruleinfo_tree = etree.parse(StringIO(content[idx1:idx2]))
            ruleinfo_elements = ruleinfo_tree.findall(".//Rule")

        build_id_elem = tree.find( './/{xmlns://www.fortifysoftware.com/schema/fvdl}Build/{xmlns://www.fortifysoftware.com/schema/fvdl}BuildID')
        if build_id_elem is not None:
            build_id = build_id_elem.text
        else:
            build_id = "NST_directory"

        base = tree.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceBasePath').text

        # Process default Accuracy, Probability and Impact values per category
        scapath = self.vim.eval('g:fortify_SCAPath')

        default_accuracy = {}
        default_probability = {}
        default_impact = {}
        if scapath:
            for t in ["accuracy", "impact", "probability"]:
                path = os.path.join(scapath, "Core", "config", "LegacyMappings", "%s.properties" % (t,))
                try:
                    f = open(path, 'r')
                    for l in f.readlines():
                        l = l.replace('\n', '')
                        l = l.replace('\\', '')
                        (analyzer_category, value) = l.split('=')
                        if t == "accuracy":
                            default_accuracy[analyzer_category] = value
                        elif t == "impact":
                            default_impact[analyzer_category] = value
                        elif t == "probability":
                            default_probability[analyzer_category] = value
                        f.close()
                except:
                    pass

        # Process Node Pool
        node_pool = {}
        node_elements = tree.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}UnifiedNodePool/{xmlns://www.fortifysoftware.com/schema/fvdl}Node')
        if node_elements is not None:
            for node_element in node_elements:
                node = {}
                node['sline'] = -1
                node['is_folded'] = 1
                node['id'] = node_element.get('id')
                action_element = node_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Action")
                if action_element is not None:
                    node['label'] = action_element.text
                    node['type'] = action_element.get('type')
                node['children_ids'] = []
                # TODO: We are getting all Reason//NodeRefs, can we have several traces? can we have regular Nodes? 
                noderef_elements = node_element.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Reason//{xmlns://www.fortifysoftware.com/schema/fvdl}NodeRef")
                if noderef_elements is not None:
                    for noderef_element in noderef_elements:
                        id = noderef_element.get('id')
                        if id is not None:
                            node['children_ids'].append(id)
                rule_element = node_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Reason/{xmlns://www.fortifysoftware.com/schema/fvdl}Rule")
                if rule_element is not None:
                    node['ruleid'] = rule_element.get('ruleID')
                node['facts'] = []
                if node_element.get('label') is not None:
                    node['facts'].append(node_element.get('label'))
                fact_elements = node_element.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Knowledge/{xmlns://www.fortifysoftware.com/schema/fvdl}Fact")
                if fact_elements is not None:
                    for fact_element in fact_elements:
                        fact_type = fact_element.get('type')
                        fact_text = fact_element.text
                        if fact_type is None:
                            node['facts'].append(fact_text)
                        else:
                            node['facts'].append(fact_type + ": " + fact_text)
                source_element = node_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation")
                if source_element is not None:
                    node['path'] = os.path.join(base, source_element.get('path'))
                    node['line'] = source_element.get('line')
                    node['filename'] = ntpath.basename(node['path'])
                node_pool[node['id']] = node

        # Process Node Pool to resolve child nodes
        for node in node_pool.values():
            node['children'] = []
            for noderef in node['children_ids']:
                if node_pool[noderef] is not None:
                    node['children'].append(node_pool[noderef])

        # Collect rule metadata
        if ruleinfo_elements is not None:
            rule_info = {}
            for ruleinfo_element in ruleinfo_elements:
                rule_metadata = {}
                ruleid = ruleinfo_element.get('id')
                metadata_elements = ruleinfo_element.findall(".//Group")
                if metadata_elements is not None:
                    for metadata_element in metadata_elements:
                        key = metadata_element.get('name')
                        value = metadata_element.text
                        rule_metadata[key] = value
                rule_info[ruleid] = rule_metadata

        # Process vulnerabilities
        vulns = tree.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Vulnerability')

        scaninfo = {}
        scaninfo['nissues'] = len(vulns)
        scaninfo['build_id'] = build_id
        scaninfo['sline'] = {}

        categories = {}

        for v in vulns:
            category_name = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Type').text
            analyzer = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}AnalyzerName').text
            instanceID = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}InstanceID').text
            confidence = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Confidence').text
            subcategoryElement = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Subtype')
            if subcategoryElement is not None:
                category_name += ": " + subcategoryElement.text

            locationElement = v.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Trace/{xmlns://www.fortifysoftware.com/schema/fvdl}Primary/{xmlns://www.fortifysoftware.com/schema/fvdl}Entry/{xmlns://www.fortifysoftware.com/schema/fvdl}Node[@isDefault='true']/{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation")
            if locationElement is not None:
                path = os.path.join(base, locationElement.get('path'))
                line = locationElement.get('line')
            else:
                continue

            # Create new issue to represent vulnerability 
            issue = {}
            issue['analyzer'] = analyzer
            issue['iid'] = instanceID
            issue['confidence'] = confidence
            issue['line'] = line
            issue['path'] = path
            issue['filename'] = ntpath.basename(path)
            issue['sline'] = -1
            issue['is_folded'] = 1
            issue['ruleids'] = []

            # External entries
            external_entries = []
            external_entry_elements = v.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}ExternalEntries")
            if external_entry_elements is not None:
                for external_entry_element in external_entry_elements:
                    entry_elements = external_entry_element.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Entry")
                    if entry_elements is not None:
                        for entry_element in entry_elements:
                            entry = {}
                            entry['type'] = entry_element.get('type')
                            entry['label'] = entry_element.get('name')
                            entry['url'] = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}URL").text
                            source_element = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation")
                            if source_element is not None:
                                entry['path'] = os.path.join(base, source_element.get('path'))
                                entry['line'] = source_element.get('line')
                                entry['filename'] = ntpath.basename(entry['path'])
                            external_entries.append(entry)
            issue['external_entries'] = external_entries

            # Traces
            traces = []
            trace_elements = v.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Trace")

            if trace_elements is not None:
                for i, trace_element in enumerate(trace_elements):

                    trace = []
                    entry_elements = trace_element.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Entry")
                    if entry_elements is not None:
                        for entry_element in entry_elements:
                            # Nodes
                            # TODO: Most of this code is repited from unified pool processing. refactor
                            for node_element in entry_element:
                                node = {}
                                # Common
                                node['sline'] = -1
                                node['is_folded'] = 1
                                node['children'] = []
                                source_element = node_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation")
                                node['path'] = "unknown"
                                node['filename'] = "unknown"
                                node['line'] = 0
                                if source_element is not None:
                                    node['path'] = os.path.join(base, source_element.get('path'))
                                    node['line'] = source_element.get('line')
                                    node['filename'] = ntpath.basename(node['path'])
                                tag = node_element.tag
                                if tag == "{xmlns://www.fortifysoftware.com/schema/fvdl}Node":
                                    # Structural
                                    if analyzer == "structural":
                                        if node_element.get('label') is not None:
                                            node['label'] = node_element.get('label')
                                        else:
                                            node['label'] = ""
                                        node['facts'] = []
                                        fact_elements = node_element.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Knowledge/{xmlns://www.fortifysoftware.com/schema/fvdl}Fact")
                                        if fact_elements is not None:
                                            for fact_element in fact_elements:
                                                fact_type = fact_element.get('type')
                                                fact_text = fact_element.text
                                                if fact_type is None:
                                                    node['facts'].append(fact_text)
                                                else:
                                                    node['facts'].append(fact_type + ": " + fact_text)
                                    # Configuration
                                    elif analyzer == "configuration":
                                        action_element = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Action")
                                        if action_element is not None:
                                            node['label'] = action_element.text if action_element.text is not None else ""
                                            node['type'] = action_element.get('type', '')
                                        else:
                                            node['label'] = ""
                                            node['type'] = ""
                                        rule_element = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Reason/{xmlns://www.fortifysoftware.com/schema/fvdl}Rule")
                                        if rule_element is not None:
                                            node['ruleid'] = rule_element.get('ruleID')
                                    # Semantic
                                    elif analyzer == "content":
                                        node['ruleid'] = v.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}ClassID").text
                                        node['label'] = ""
                                        node['type'] = ""
                                    # Semantic
                                    elif analyzer == "semantic":
                                        action_element = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Action")
                                        if action_element is not None:
                                            node['label'] = action_element.text if action_element.text is not None else ""
                                            node['type'] = action_element.get('type', '')
                                        else:
                                            node['label'] = ""
                                            node['type'] = ""
                                    # Controlflow
                                    elif analyzer == "controlflow":
                                        action_element = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Action")
                                        if action_element is not None:
                                            node['label'] = action_element.text if action_element.text is not None else ""
                                            node['type'] = action_element.get('type', '')
                                        else:
                                            node['label'] = ""
                                            node['type'] = ""
                                        rule_element = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Reason/{xmlns://www.fortifysoftware.com/schema/fvdl}Rule")
                                        if rule_element is not None:
                                            node['ruleid'] = rule_element.get('ruleID')
                                    # Dataflow
                                    elif analyzer == "dataflow":
                                        action_element = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Action")
                                        if action_element is not None:
                                            node['label'] = action_element.text if action_element.text is not None else ""
                                            node['type'] = action_element.get('type', '')
                                        else:
                                            node['label'] = ""
                                            node['type'] = ""
                                        noderef_elements = node_element.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Reason//{xmlns://www.fortifysoftware.com/schema/fvdl}NodeRef")
                                        if noderef_elements is not None:
                                            for noderef_element in noderef_elements:
                                                id = noderef_element.get('id')
                                                if id is not None:
                                                    # TODO: It may be the case the NodeRef has not been processed into the pool, yet
                                                    if id in node_pool:
                                                        node['children'].append(node_pool[id])
                                        rule_element = entry_element.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Reason/{xmlns://www.fortifysoftware.com/schema/fvdl}Rule")
                                        if rule_element is not None:
                                            node['ruleid'] = rule_element.get('ruleID')
                                        node['facts'] = []
                                        fact_elements = node_element.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Knowledge/{xmlns://www.fortifysoftware.com/schema/fvdl}Fact")
                                        if fact_elements is not None:
                                            for fact_element in fact_elements:
                                                fact_type = fact_element.get('type')
                                                fact_text = fact_element.text
                                                if fact_type is None:
                                                    node['facts'].append(fact_text)
                                                else:
                                                    node['facts'].append(fact_type + ": " + fact_text)

                                    if not node.get('ruleid', None):
                                            node['ruleid'] = v.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}ClassID").text
                                    if node.get('ruleid', None):
                                            issue['ruleids'].append(node['ruleid'])
                                elif tag == "{xmlns://www.fortifysoftware.com/schema/fvdl}NodeRef":

                                    id = node_element.get('id')
                                    if id is not None:
                                        node = node_pool[id]
                                trace.append(node)
                    traces.append(trace)
            issue['traces'] = traces
            issue['active_trace'] = 0

            # Calculate Friority
            issue['friority'] = ''
            threshold = float(3)

            impact = -1
            probability = -1
            accuracy = -1
            confidence = float(issue['confidence'])

            # Try with values from FVDL first
            for ruleid in issue['ruleids']:
                metadata = rule_info.get(ruleid, None)
                if metadata is not None:
                    if probability < 0 and metadata.get('Probability', None):
                        probability = float(metadata['Probability'])
                    if accuracy < 0 and metadata.get('Accuracy', None):
                        accuracy = float(metadata['Accuracy'])
                    if impact < 0 and metadata.get('Impact', None):
                        impact = float(metadata['Impact'])
                if accuracy > -1 and impact > -1 and probability > -1:
                    break

            # Try with default values
            dkey = issue['analyzer'] + '.' + category_name
            if impact < 0:
                    impact = float(default_impact.get(dkey, -1))
            if probability < 0:
                    probability = float(default_probability.get(dkey, -1))
            if accuracy < 0:
                    accuracy = float(default_accuracy.get(dkey, -1))

            if accuracy > -1 and impact > -1 and probability > -1:
                # Calculate derived likelihood
                likelihood = (probability * accuracy * confidence) / float(25)

                # Calculate Friority
                if likelihood >= 0 and impact >= 0:
                    if likelihood >= threshold and impact >= threshold:
                        issue['friority'] = 'critical'
                    elif likelihood < threshold and impact >= threshold:
                        issue['friority'] = 'high'
                    elif likelihood >= threshold and impact < threshold:
                        issue['friority'] = 'medium'
                    elif likelihood < threshold and impact < threshold:
                        issue['friority'] = 'low'

            # Add new category if necessary
            if not category_name in categories:
                category = {}
                category['name'] = category_name
                category['is_folded'] = 1
                category['issues'] = []
                categories[category_name] = category

            # Append issue to its corresponding category
            categories[category_name]['issues'].append(issue)

        # Sort categories
        def SortCategoryByName(category):
                return category['name']
        categories = list(categories.values())
        categories = sorted(categories, key=SortCategoryByName)

        # Sort issues
        def SortIssuesByFileAndLine(issue):
            return issue['filename'] + ":" + issue['line'].zfill(5)
        for category in categories:
            category['issues'] = sorted(category['issues'], key=SortIssuesByFileAndLine)

        # Group nodes
        for category in categories:
            issues = category['issues']
            new_issues = []
            count = 0
            for issue in issues:
                # Filter/Map functions
                def FindSameSinkIssues(ni):
                    if (issue['path'] == ni['path'] and issue['line'] == ni['line']):
                        return True
                    else:
                        return False
                def MarkAsMembers(ni):
                    ni['belongs_to_group'] = 1
                    return ni

                if 'belongs_to_group' not in issue:
                    # Get issues with same sink
                    same_sink_issues = list(filter(FindSameSinkIssues, issues))

                    # If there are more than one, create a group
                    size = len(same_sink_issues)
                    if size > 1:
                            group = {}
                            group['issues'] = list(map(MarkAsMembers, same_sink_issues))
                            group['path'] = issue['path']
                            group['filename'] = issue['filename']
                            group['line'] = issue['line']
                            group['count'] = size
                            group['is_folded'] = 1

                            # Replace issue with group
                            new_issues.append(group)
                    else:
                            # Append individual issue
                            new_issues.append(issue)

                    count += size

            category['issues'] = new_issues
            category['count'] = count

        scaninfo['categories'] = categories

        return str(scaninfo)

    ######################
    #   SearchInGoogle   #
    ######################
    @neovim.command('SearchInGoogle', range='', nargs='*', sync=True)
    def search_in_google(self, args, range):
        query, lang = self.get_function_identifier()
        if query and lang:
            url = 'http://www.google.com/search?&btnI=1&q='
            url += query.replace(' ','%20')
            webbrowser.open_new_tab(url)

    ######################
    #    SearchInDash   #
    ######################
    @neovim.command('SearchInDash', range='', nargs='*', sync=True)
    def search_in_dash(self, args, range):
        query, lang = self.get_function_identifier()
        if query and lang:
            syntax_docset_map = { "dotnet": ["net"], "java": ["java", "javafx", "grails", "groovy", "playjava", "spring", "cvj", "processing"], "cpp": ["cpp", "net", "boost", "qt", "cvcpp", "cocos2dx", "c", "manpages"], "javascript": ["javascript", "jquery", "jqueryui", "jquerym", "backbone", "marionette", "meteor", "sproutcore", "moo", "prototype", "bootstrap", "foundation", "lodash", "underscore", "ember", "sencha", "extjs", "knockout", "zepto", "yui", "d3", "svg", "dojo", "coffee", "nodejs", "express", "chai", "html", "css", "cordova", "phonegap", "unity3d"], "objc": ["cpp", "iphoneos", "macosx", "appledoc", "cocos2d", "cocos3d", "kobold2d", "sparrow", "c", "manpages"], "php": ["php", "wordpress", "drupal", "zend", "laravel", "yii", "joomla", "ee", "codeigniter", "cakephp", "symfony", "typo3", "twig", "smarty", "html", "mysql", "sqlite", "mongodb", "psql", "redis"], "python": ["python", "django", "twisted", "sphinx", "flask", "cvp"], "ruby": ["ruby", "rubygems", "rails"], "sql": ["mysql", "sqlite", "psql"]}
            keys = syntax_docset_map[lang]
            subprocess.call(['open', 'dash-plugin://keys=%s&query=%s' % (','.join(keys), quote(query))])

    def get_function_identifier(self):
        rule, start, end = self.get_rule()
        if not rule:
            return (None, None)
        rule = "\n".join(rule)
        isRegex = False
        parser = ltree.XMLParser(strip_cdata=False)
        root = ltree.fromstring(rule, parser)
        if None == root.find("FunctionIdentifier") and None == root.find("StoreFunction"):
            print('Rule has no FunctionIdentifier')
            return (None, None)
        else:
            lang = root.attrib['language']
            fid = root.find("FunctionIdentifier")
            if fid is None:
                fid = root.find("StoreFunction")
            ns = fid.find("NamespaceName")
            if ns is not None:
                ns_pattern = ns.find("Pattern")
                ns_value = ns.find("Value")
                if ns_pattern is not None:
                    isRegex = True
                    ns_value = ns_pattern.text
                elif ns_value is not None:
                    ns_value = ns_value.text
            else:
                ns_value = ""
            cn = fid.find("ClassName")
            if cn is not None:
                cn_pattern = cn.find("Pattern")
                cn_value = cn.find("Value")
                if cn_pattern is not None:
                    isRegex = True
                    cn_value = cn_pattern.text
                elif cn_value is not None:
                    cn_value = cn_value.text
            else:
                cn_value = ""
            delimiter = "."
            if ns_value is None:
                ns_value = ""
                delimiter = ""
            if cn_value is None:
                cn_value = ""
                delimiter = ""
            query = str(ns_value) + delimiter + str(cn_value)
            return (query, lang)

    ######################
    #    SearchRuleWeb   #
    ######################
    @neovim.command('SearchRuleWeb', range='', nargs='*', sync=True)
    def search_ruleweb(self, args, range):
        query  = str(args)[1:-1].replace("'", "").replace(', ', ' ')
        url = 'http://10.100.221.65:8080'
        query_url = url + "/query?q=n:500 %s" % query
        query_url = query_url.replace(' ','%20')
        query_json = self.get_url(query_url)
        if query_json is not None:
            results = json.loads(query_json)
            message = results['messages']
            text = '\n'.join(message) + "\n"
            text = "<Results>\n%s</Results>\n\n" % text
            rules = results['results']
            xml = '''<?xml version="1.0" encoding="UTF-8"?><RulePack xmlns="xmlns://www.fortifysoftware.com/schema/rules" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="RulePack">\n\n'''
            for rule in rules:
              xml += "%s\n\n" % rule['source']
            xml += '\n\n</RulePack>'
            xml = xml.replace('\r','')
            self.vim.command('enew')
            self.vim.command('set ft=fortifyrulepack')
            self.vim.command('setlocal buftype=nofile')
            self.vim.command('setlocal bufhidden=hide')
            self.vim.command('setlocal noswapfile')
            self.vim.command('map <buffer> q :bd<CR>')
            self.vim.current.buffer.append(str(text + xml).split("\n"), 0)

    ######################
    #     RuleHistory    #
    ######################
    @neovim.command('RuleHistory', range='', nargs='*', sync=True)
    def rule_history(self, args, range):
        url = 'http://15.214.176.42:8080'
        query_url = url + "/query?q=%s" % query
        query_url = query_url.replace(' ','%20')
        query_json = self.get_url(query_url)
        if query_json is not None:
            results = json.loads(query_json)
            if len(results['histItems']) == 0:
                query_json = _get_url(query_url[0:-1])
                if query_json is not None:
                    results = json.loads(query_json)
            messages = results['messages']
            messages.insert(0,'<!--')
            messages.append('-->')
            messages.append('')
            xml = "\n\n".join(messages)
            if len(results['histItems']) > 0:
                xml += '''<?xml version="1.0" encoding="UTF-8"?><RulePack xmlns="xmlns://www.fortifysoftware.com/schema/rules" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="RulePack">\n\n'''
                for item in results['histItems']:
                    xml += """<!--\n%s v=%s %s %s in changelist %s on %s\n\n%s-->\n\n%s\n\n""" % (item['ruleId'], item['formatVersion'], item['event'], item['author'], item['changeId'], item['dateTime'],item['comment'],item['source'],)
                    xml = xml.replace('\r','')
                xml += '\n\n</RulePack>'
            self.vim.command('enew')
            self.vim.command('set ft=fortifyrulepack')
            self.vim.command('setlocal buftype=nofile')
            self.vim.command('setlocal bufhidden=hide')
            self.vim.command('setlocal noswapfile')
            self.vim.command('map <buffer> q :bd<CR>')
            self.vim.current.buffer.append(str(xml).split("\n"), 0)

    def get_url(self, url):
        try:
            body = requests.get(url, timeout=10).text
        except:
            print('Error connecting to: %s' % (url))
            return None
        else:
            return body

    ######################
    #     Translate      #
    ######################
    @neovim.command('Translate', complete='file', range='', nargs='*', sync=True)
    def translate(self, args, range):
        if len(args) == 0:
            self.status_message("Error: Missing arguments. Usage: Translate <path> [<mode>] [<build id>]")
            return
        elif len(args) == 1:
            self._translate(args[0])
        elif len(args) == 2:
            self._translate(args[0], args[1])
        elif len(args) == 3:
            self._translate(args[0], args[1], args[2])
        elif len(args) > 3:
            self.status_message("Error: Too many arguments. Usage: Translate <path> [<mode>] [<build id>]")
            return

    ######################
    #        Scan        #
    ######################
    @neovim.command('Scan', range='', nargs='*', sync=True)
    def scan(self, args, range):
        if len(args) == 0:
            self._scan()
        elif len(args) == 1:
            self._scan(args[0], structural_dump=False, generate_fvdl=False, validate_rules=False, scan_nsts=False)
        elif len(args) == 2:
            self._scan(args[0], args[1], structural_dump=False, generate_fvdl=False, validate_rules=False, scan_nsts=False)
        elif len(args) > 2:
            self.status_message("Error: Too many arguments. Usage: Scan [<build id>] [<rulepack>]")

    #########################
    #  GenerateExpectedFVDL #
    #########################
    @neovim.command('GenerateExpectedFVDL', range='', nargs='*', sync=True)
    def generate_expected_fvdl(self, args, range):
        if len(args) == 0:
            self._scan(structural_dump=False, generate_fvdl=True, validate_rules=False, scan_nsts=False)
        elif len(args) == 1:
            self._scan(args[0], structural_dump=False, generate_fvdl=True, validate_rules=False, scan_nsts=False)
        elif len(args) == 2:
            self._scan(args[0], args[1], structural_dump=False, generate_fvdl=True, validate_rules=False, scan_nsts=False)
        elif len(args) > 2:
            self.status_message("Error: Too many arguments. Usage: GenerateExpectedFVDL [<build id>] [<rulepack>]")

    ######################
    #      ScanNSTs      #
    ######################
    @neovim.command('ScanNSTs', complete='file', range='', nargs='*', sync=True)
    def scan_nsts(self, args, range):
        if len(args) == 0:
            self.status_message("Error: Too few arguments. Usage: ScanNSTs [<NST dir>] [<rulepack>]")
        elif len(args) == 1:
            self._scan(args[0], structural_dump=False, generate_fvdl=False, validate_rules=False, scan_nsts=True)
        elif len(args) == 2:
            self._scan(args[0], args[1], structural_dump=False, generate_fvdl=False, validate_rules=False, scan_nsts=True)
        elif len(args) > 2:
            self.status_message("Error: Too many arguments. Usage: ScanNSTs [<NST dir>] [<rulepack>]")

    ######################
    #   ValidateRules    #
    ######################
    @neovim.command('ValidateRules', complete='file', range='', nargs='*', sync=True)
    def validate_rules(self, args, range):
        if len(args) == 0:
            self.status_message("Error: Too few arguments. Usage: ValidateRules [<rulepack>]")
        elif len(args) == 1:
            self._scan(None, args[0], structural_dump=False, generate_fvdl=False, validate_rules=True, scan_nsts=False)
        elif len(args) > 1:
            self.status_message("Error: Too many arguments. Usage: ValidateRules [<rulepack>]")

    ######################
    #   StructuralDump   #
    ######################
    @neovim.command('StructuralDump', range='', nargs='*', sync=True)
    def structural_dump(self, args, range):
        if len(args) == 0:
            self._scan(structural_dump=True, generate_fvdl=False, validate_rules=False, scan_nsts=False)
        elif len(args) == 1:
            self._scan(args[0], structural_dump=True, generate_fvdl=False, validate_rules=False, scan_nsts=False)
        elif len(args) == 2:
            self._scan(args[0], args[1], structural_dump=True, generate_fvdl=False, validate_rules=False, scan_nsts=False)
        elif len(args) > 2:
            self.status_message("Error: Too many arguments. Usage: StructuralDump [<build dir>] [<rulepack>]")

    ######################
    #   MakeMobileBuild  #
    ######################
    @neovim.command('MakeMobileBuild', range='', nargs='*', sync=True)
    def make_mobile_build(self, args, range):
        if len(args) == 0:
            self._scan(structural_dump=True, generate_fvdl=False, validate_rules=False, scan_nsts=False)
            self.make_mobile_build()
        elif len(args) == 1:
            self.make_mobile_build(args[0])
        elif len(args) == 2:
            self.make_mobile_build(args[0], args[1])
        elif len(args) > 2:
            self.status_message("Error: Too many arguments. Usage: MakeMobileBuild [<build id>] [<mode>]")

    def _translate(self, file_path, mode='all', build_id=None):
        current_path = self.vim.eval("resolve(expand('%:p'))")
        if current_path.endswith(file_path):
            file_path = current_path
        if os.path.isfile(file_path):
            TranslateFileCommand(self.vim).run(file_path, build_id)
        elif os.path.isdir(file_path):
            TranslateProjectCommand(self.vim).run(file_path, mode, build_id)
        else:
            self.status_message("Incorrect path: %s" % file_path)

    def _scan(self, build_id=None, rules_path=None, structural_dump=False, generate_fvdl=False, validate_rules=False, scan_nsts=False):
        if build_id is not None and rules_path is None:
            if build_id == '%' or os.path.isfile(build_id):
                rules_path = build_id
                build_id = None

        if build_id is None:
            build_id = self.vim.eval("g:fortify_buildid")
        else:
            self.vim.command('let g:fortify_buildid = "%s"' % build_id)

        if rules_path == "%":
            rules_path = self.vim.eval("resolve(expand('%:p'))")

        if validate_rules:
            ScanCommand(self.vim).run(None, rules_path, structural_dump=False, generate_fvdl=False, validate_rules=True, scan_nsts=False)
        elif build_id != "" and build_id is not None:
            ScanCommand(self.vim).run(build_id, rules_path, structural_dump, generate_fvdl, validate_rules, scan_nsts)
        else:
            self.status_message("Incorrect build id")

    def make_mobile_build(self, build_id=None, out_path=None):
        if build_id is not None and out_path is None:
            if os.path.isdir(build_id):
                out_path = build_id
                build_id = None

        if build_id is None:
            build_id = self.vim.eval("g:fortify_buildid")
            if build_id == "":
                self.status_message("Incorrect build id")
                return

        if out_path is None:
            out_path = self.vim.eval("getcwd()")

        mbs_path = os.path.join(out_path, "%s.mbs" % build_id)

        self.vim.command("call fortify#OpenTestPaneWindow()")
        self.vim.command("call fortify#ClearTestPaneWindow()")
        self.vim.command("let g:fortify_message = 'Generating Mobile Build for %s in %s)'" % (build_id, out_path))
        self.vim.command("let g:fortify_commandlist = [['sourceanalyzer', '-b', '%s', '-make-mobile'], ['sourceanalyzer', '-b', '%s', '-export-build-session', '%s']]" % (build_id, build_id, mbs_path,))
        self.vim.command("call g:fortify#InvokeChainedCommandsHandler('', '', '')")

    ######################
    #      RunTests      #
    ######################
    @neovim.command('RunTests', range='', nargs='*', sync=False)
    def run_tests(self, args, range):
        self.vim.command("call fortify#OpenTestPaneWindow()")
        if len(args) == 0:
            self.status_message("Error, not enough arguments")
            return
        elif len(args) == 1:
            fpr_path = args[0]
            generate_fvdl = False
        elif len(args) == 2:
            if args[1] == "1":
                generate_fvdl = True
            else:
                generate_fvdl = False
        elif len(args) > 2:
            self.status_message("Error, too many arguments")
            return

        tmpdir = os.path.join(tempfile.gettempdir(), str(uuid.uuid4()))
        if not os.path.exists(tmpdir):
            os.makedirs(tmpdir)
        cwd = self.vim.eval("getcwd()")
        if ".fvdl" in fpr_path:
            fvdl_path = fpr_path
            tree = self.parse_fvdl(fvdl_path)
        else:
            # Extracting FPR contents in tmp dir
            try:
                zip = zipfile.ZipFile(fpr_path)
                zip.extract('audit.fvdl', tmpdir)
                fvdl_path = os.path.join(tmpdir, 'audit.fvdl')
                tree = self.parse_fvdl(fvdl_path)
            except Exception as e:
                self.display("Cannot open FPR %s" % str(e))
                return

        # Add Vulnerabilities to Search Index
        ix = self.process_vulns(tree, tmpdir)
        # Get project base path
        basepath = tree.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceBasePath').text
        # Scan source code for files
        build_id_elem = tree.find( './/{xmlns://www.fortifysoftware.com/schema/fvdl}Build/{xmlns://www.fortifysoftware.com/schema/fvdl}BuildID')
        if build_id_elem is not None:
            build_id = build_id_elem.text
        else:
            build_id = "NST_directory"
        files = tree.findall( './/{xmlns://www.fortifysoftware.com/schema/fvdl}SourceFiles/{xmlns://www.fortifysoftware.com/schema/fvdl}File/{xmlns://www.fortifysoftware.com/schema/fvdl}Name')
        regex = re.compile(r'^.*\[RuleTest\](.*)$')
        testsFound = False
        passed = 0
        failures = 0

        if generate_fvdl:
            shutil.copyfile(fvdl_path, os.path.join(cwd, build_id + ".expected"))

        memory_opts = self.vim.eval("g:fortify_MemoryOpts")
        scan_opts = self.vim.eval("g:fortify_ScanOpts")

        self.display("Build ID: %s" % build_id)
        self.display("FPR File: %s" % fpr_path)
        self.display("Memory Settings: %s" % str(memory_opts).strip('[]'))
        self.display("Scan Settings: %s" % str(scan_opts).strip('[]'))
        self.display("Project Base Path: %s" % basepath)
        self.display("Looking for RuleTests: ")

        for fileElement in files:
            filename = fileElement.text
            if self.is_file_binary(filename):
                self.display("  \"%s\" is binary - no markup expected, ignore" % filename)
                continue
            try:
                f = codecs.open(os.path.join(basepath, filename), 'r')
                lines = f.readlines()
                for i, line in enumerate(lines):
                    tests = regex.findall(line)
                    if tests is not None and len(tests) > 0:
                        testsFound = True
                        for test in tests:
                            code = self.findCode(regex, lines, i)
                            if "/extracted/" not in filename:
                                res = self.test(str(test).replace('-->','').strip(), filename,  code + 1, ix, basepath)
                                if res[0]:
                                    passed = passed + 1
                                else:
                                    failures = failures + 1
                                    self.display(str(test).replace('-->','').strip(), filename, code+1,basepath)
                f.close()
            except Exception as e:
                self.display("Error while processing source files for rule tests: " + str(e))
                # Corner case for languages like cpp that use index.xml as a map
                # between internal files and source code
                if os.path.isfile(os.path.join(tmpdir, "src-archive", "index.xml")):
                    filemap = etree.parse(os.path.join(tmpdir, "src-archive", "index.xml"))
                    files = filemap.findall('.//properties/entry')
                    for fileElement in files:
                        filename = os.path.join(tmpdir, fileElement.text)
                        try:
                            f = codecs.open(os.path.join(basepath, filename), 'r')
                            lines = f.readlines()
                            for i, line in enumerate(lines):
                                tests = regex.findall(line)
                                for test in tests:
                                    code = self.findCode(regex, lines, i)
                                    res = self.test(str(test).strip(), filename,  code + 1, ix, basepath)
                                    if res[0]:
                                        passed = passed + 1
                                    else:
                                        failures = failures + 1
                                        self.display(str(test).strip(), filename, code+1,basepath)
                                    testsFound = True
                            f.close()
                        except:
                            pass

        self.display("Total %s, %s passed, %s failures" % (str(passed + failures), str(passed), str(failures),))

        if not testsFound:
            self.display("No valid RuleTests found")

        shutil.rmtree(tmpdir)

    def findCode(self, regex, lines, i):
        if i < len(lines) and regex.search(lines[i + 1]):
            return self.findCode(regex, lines, i + 1)
        else:
            return i + 1

    def process_vulns(self, tree, tmpdir):
        issues = {}
        vulns = tree.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Vulnerability')
        self.display("Found: %d issues" % len(vulns))
        schema = Schema(title=TEXT(stored=True), category=TEXT(stored=True), subcategory=TEXT(stored=True), path=TEXT(stored=True), line=TEXT(stored=True), analyzer=TEXT(stored=True))
        ix = create_in(tmpdir, schema)
        writer = ix.writer()
        for v in vulns:
            category = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Type').text
            analyzer = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}AnalyzerName').text
            subcategoryElement = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Subtype')
            subcategory = ""
            if subcategoryElement is not None:
                subcategory = subcategoryElement.text
            if (subcategory is not None and subcategory is not ""):
                title = category + ": " + subcategory
            else:
                title = category

            locationElements = v.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Trace/{xmlns://www.fortifysoftware.com/schema/fvdl}Primary/{xmlns://www.fortifysoftware.com/schema/fvdl}Entry/{xmlns://www.fortifysoftware.com/schema/fvdl}Node/{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation')
            for locationElement in locationElements:
                if locationElement is not None:
                    path = locationElement.get('path')
                    line = locationElement.get('line')
                    writer.add_document(title=title, category=category, subcategory=subcategory, path=path, line=line, analyzer=analyzer)


            instanceID = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}InstanceID').text.encode('utf-8')

            # Structural issues
            if analyzer == "structural":
                issue = {
                    'instanceID': instanceID,
                    'analyzer': analyzer,
                    'category': title,
                    'node_files': None,
                    'node_lines': None,
                    'node_labels': None
                }
                for locationElement in locationElements:
                    if locationElement is not None:
                        path = locationElement.get('path')
                        line = locationElement.get('line')
                        if issue.get('node_files', None):
                            issue['node_files'].append(path)
                        else:
                            issue['node_files'] = [path]
                        if issue.get('node_lines', None):
                            issue['node_lines'].append(line)
                        else:
                            issue['node_lines'] = [line]
                nodeElements = v.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Trace/{xmlns://www.fortifysoftware.com/schema/fvdl}Primary/{xmlns://www.fortifysoftware.com/schema/fvdl}Entry/{xmlns://www.fortifysoftware.com/schema/fvdl}Node')
                for nodeElement in nodeElements:
                    if nodeElement is not None:
                        label = nodeElement.get('label')
                        if issue.get('node_labels', None):
                            issue['node_labels'].append(label)
                        else:
                            issue['node_labels'] = [label]
                if None not in issue.values():
                    signature = "%s__%s||%s||%s" % (analyzer, "::".join(str(issue.get('node_files'))), "::".join(str(issue.get('node_lines'))), "::".join(str(issue.get('node_labels'))),)
                    if issues.get(signature, None):
                        issues[signature].append(issue)
                    else:
                        issues[signature] = [issue]

            # Dataflow issues
            if analyzer == "dataflow":
                issue = {
                    'instanceID': instanceID,
                    'analyzer': analyzer,
                    'category': title,
                    'sink_file': None,
                    'sink_line': None,
                    'sink_action': None,
                    'source_file': None,
                    'source_line': None,
                    'source_action': None
                }

                # sink file and line
                sinkElement = locationElements[-1]
                if sinkElement is not None:
                    issue['sink_file'] = sinkElement.get('path')
                    issue['sink_line'] = sinkElement.get('line')

                    actionElement = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Node/{xmlns://www.fortifysoftware.com/schema/fvdl}Action')
                    if actionElement is not None:
                        issue['sink_action'] = actionElement.text

                # source file and line
                refElements = v.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Trace/{xmlns://www.fortifysoftware.com/schema/fvdl}Primary/{xmlns://www.fortifysoftware.com/schema/fvdl}Entry/{xmlns://www.fortifysoftware.com/schema/fvdl}NodeRef')
                sourceRefElement = refElements[0]
                sourceid = sourceRefElement.get('id')
                if sourceid is not None:
                    sourceElement = tree.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}UnifiedNodePool/{xmlns://www.fortifysoftware.com/schema/fvdl}Node[@id="%s"]/{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation' % sourceid)
                    if sourceElement is not None:
                        issue['source_file'] = sourceElement.get('path')
                        issue['source_line'] = sourceElement.get('line')

                    sourceActionElement = tree.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}UnifiedNodePool/{xmlns://www.fortifysoftware.com/schema/fvdl}Node[@id="%s"]/{xmlns://www.fortifysoftware.com/schema/fvdl}Action' % sourceid)
                    if sourceActionElement is not None:
                        issue['source_action'] = sourceActionElement.text
                if None not in issue.values():
                    signature = "%s__%s::%s||%s==%s::%s||%s" % (analyzer, issue.get('sink_file', None), issue.get('sink_line', None), issue.get('sink_action', None), issue.get('source_file', None), issue.get('source_line', None), issue.get('source_action', None),)
                    if issues.get(signature, None):
                        issues[signature].append(issue)
                    else:
                        issues[signature] = [issue]

        writer.commit()
        return ix

    def test(self, query, path, line, ix, basepath):
        results = None
        negativeTest = ""
        if query[:1] == "!":
            query = query[1:].strip()
            negativeTest = "!"
        m = re.search(r'\sline\:(\d+)(\s|$)', query)
        if m is not None:
            mod = m.group(1)
            query = query.replace(' line:' + str(mod), '')
            line +=int(mod)
        bugid = None
        b = re.search(r'\sbugid\:(\d+)(\s|$)', query)
        if b is not None:
            bugid = b.group(1)
            query = query.replace(' bugid:' + str(bugid), '')
        bugstr = "" if bugid is None else " (Bug %s)" % (str(bugid),)
        if ix is not None:
            uquery = str(query + ' path:"' + path + '" line:' + str(line))
            parser =  qparser.QueryParser("title", schema=ix.schema)
            parser.add_plugin(qparser.PhrasePlugin())
            wquery = parser.parse(uquery)
            with ix.searcher() as searcher:
                results = searcher.search(wquery, limit=100)
                if negativeTest == "":
                    if len(results) > 0:
                        for res in results:
                            if str(res['line']) == str(line):
                                return (True,"")
                        output = "%s:%s %s%s%s\n" % (path, line, query, negativeTest, bugstr,)
                        return (False, output)
                    else:
                        output = "%s:%s %s%s%s\n" % (path, line, query, negativeTest, bugstr,)
                        return (False, output)
                else:
                    if len(results) == 0:
                        return (True,"")
                    else:
                        for res in results:
                            if str(res['line']) == str(line):
                                output = "%s:%s %s%s%s\n" % (path, line, query, negativeTest, bugstr,)
                                return (False, output)
                        return (True,"")
        else:
            output = "%s:%s %s%s%s\n" % (path, line, query, negativeTest, bugstr,)
            return (False, output)

    def is_file_binary(self, filename):
        extension = filename.split('.')[-1]
        if extension in ['exe', 'dll', 'jar', 'class']:
            return True
        return False

    def parse_fvdl(self, path):
        # Remove anything after UnifiedNodePool to speedup parsing
        content = open(path, 'r').read()
        idx = content.find('<Description')
        tree = None
        if idx > -1:
            tree = etree.parse(StringIO(content[:idx] + '</FVDL>'))
        else:
            tree = etree.parse(StringIO(content))
        return tree

    def display(self, message="", filename=None, linenumber=None, base="", multiline=False):
        message = message.replace("'", "")
        message = message.replace('"', "")
        if not multiline:
            message = message.replace('\n', "")
        if filename and linenumber:
            self.vim.command("call fortify#PrintToTestPane('%s', '%s', '%s', '%s')" % (message, filename, str(linenumber), base))
        else:
            self.vim.command("call fortify#PrintToTestPane('%s')" % (message))

    def status_message(self, msg):
        self.vim.command('redraw | echo "%s"' % msg)

    #############################
    # fortify#complete_internal #
    #############################
    @neovim.function('fortify#complete_internal')
    def complete_internal(self, args, range):
        text = "\n".join(self.vim.current.buffer)
        current_line = self.vim.current.line
        (row, col) = self.vim.current.window.cursor
        count = 0
        for i, l in enumerate(self.vim.current.buffer):
            if i < row - 1:
                count += len(l)+1
            else:
                count += col+1
                break
        cursor = [row,col+1,0,count]
        results = RuleCompleter().completer.complete(text, current_line, cursor)
        b = self.vim.eval('a:base')
        res = [{'word': r[1], 'menu': r[0]} for r in results if r[1].startswith(b)]
        self.vim.command("let l:res = %s" % str(res))
