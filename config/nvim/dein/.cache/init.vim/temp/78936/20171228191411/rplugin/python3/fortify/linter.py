#!/usr/local/bin/python3

# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import sys
import json
import re
import os
import collections
import tempfile
from io import BytesIO
from copy import deepcopy
from sys import exit, argv, path
from lxml import etree as ltree
from distutils.version import StrictVersion

try:
    from fortify.structural_yacc import parser, Node
    from fortify.structural_lex  import lexer
except:
    from structural_yacc import parser, Node
    from structural_lex  import lexer

# Global Vars
api = None
subtypes = None
rulevars = [] 

class ErrorType:
    """ Error class to print errors in SublimeLinter """

    WARNING = 'warning'
    ERROR = 'error'


def get_vars_list(node, varlist=[]):

    """ Given the AST root node, it parses the tree and fills a list with all the variable decalration
        The following tuples compound the list: variable name, declaration line, variable type """

    if node:
        if node.type == "type":
            if len(node.children) > 0:
                name = node.children[0].leaf
                if name:
                    varlist.append((name, node.line, node.leaf))
        else:
            for child in node.children:
                get_vars_list(child, varlist)


def get_structural_api_hierarchy():

    """ This function processes the structural XML reference and generate a dictionary where keys are the different structural types and values a list of tuples for each type property: property name, property type and property description """

    api_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, os.pardir, os.pardir, "resources", "structural_api.xml")
    api_file = open(api_path, 'r')
    api = api_file.read()
    api_root = ltree.XML(api.encode("utf-8"))
    api_file.close()
    root = api_root.xpath('./Head[text()="Structural Analyzer Rules API"]')[0]
    section = root.getnext() # Section
    paras = section.xpath('./Para')
    api = {}
    for p in paras:
        # First Level elements
        props = get_props_for_type(api_root, p.text.strip())
        api[p.text.strip().replace(' (internal)', '')] = props
        # print("1 Level " + p.text.strip() + " " + str(props))
        # Second Level elements
        for child in p.getchildren():
            if child.tag == "Indented":
                props2 = get_props_for_type(api_root, child.text.strip())
                api[child.text.strip().replace(' (internal)', '')] = props2 + props
                # print("    2 Level (" + p.text.strip() + ") " + child.text.strip() + " " + str(props2 + props))
                sibling = child.getnext()
                if sibling is not None:
                    while True:
                        if sibling is None:
                            break
                        # Third Level elements
                        if sibling.tag == "Indented2":
                            props3 = get_props_for_type(api_root, sibling.text)
                            api[sibling.text.strip().replace(' (internal)', '')] = props3 + props2 + props
                            # print("        3 Level (" + child.text.strip() + ") " + sibling.text.strip() + " " + str( props3 + props2 + props))
                        # Forth Level elements
                        elif sibling.tag == "Indented3":
                            props4 = get_props_for_type(api_root, sibling.text)
                            api[sibling.text.strip().replace(' (internal)', '')] = props4 + props3 + props2 + props
                        else:
                            break
                        sibling = sibling.getnext()
    # print("TEST " + str(api))
    api['Array'] = [("length", "int", "Length of the array")]
    return api


def get_structural_type_hierarchy():

    """ This function processes the structural XML reference and generate a dictionary where keys are the different structural types and values a list of subtypes """

    api_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, os.pardir, os.pardir, "resources", "structural_api.xml")
    api_file = open(api_path, 'r')
    api = api_file.read()
    api_root = ltree.XML(api.encode("utf-8"))
    api_file.close()
    root = api_root.xpath('./Head[text()="Structural Analyzer Rules API"]')[0]
    section = root.getnext() # Section
    paras = section.xpath('./Para')
    subtypes = {}
    for p in paras:
        # First Level elements
        ptype = str(p.text.strip().replace(' (internal)', ''))
        #print("Creating key " + ptype)
        subtypes[ptype] = []
        # Second Level elements
        for child in p.getchildren():
            if child.tag == "Indented":
                ctype = str(child.text.strip().replace(' (internal)', ''))
                #print("Creating key " + ctype)
                subtypes[ctype] = []
                #print("adding " + ctype + " as subtype of " + ptype)
                subtypes[ptype].append(ctype)
                sibling = child.getnext()
                if sibling is not None:
                    stype = ""
                    ntype = ""
                    while True:
                        if sibling is None:
                            break
                        # Third Level elements
                        if sibling.tag == "Indented2":
                            stype = str(sibling.text.strip().replace(' (internal)', ''))
                            #print("Creating key " + stype)
                            subtypes[stype] = []
                            #print("adding " + stype + " as subtype of " + ctype)
                            subtypes[ctype].append(stype)
                            subtypes[ptype].append(stype)
                        # Forth Level elements
                        elif sibling.tag == "Indented3":
                            ntype = str(sibling.text.strip().replace(' (internal)', ''))
                            #print("Creating key " + ntype)
                            subtypes[ntype] = []
                            #print("adding " + ntype + " as subtype of " + stype)
                            subtypes[stype].append(ntype)
                            subtypes[ctype].append(ntype)
                            subtypes[ptype].append(ntype)
                        else:
                            break
                        sibling = sibling.getnext()
    subtypes['int'] = []
    subtypes['Value'].append("int")
    subtypes['Number'].append("int")
    subtypes['Boolean'].append("literal")
    return subtypes


def get_structural_subtypes(ntype=None):

    """ Returns the subtypes of a given structural type or a dict with all of them """

    global subtypes
    if subtypes is None:
        subtypes = get_structural_type_hierarchy()
    if ntype is None:
        return subtypes
    else:
        return subtypes.get(ntype, [])


def get_structural_properties(ntype=None):

    """ Returns the structural properties of a given type """

    global api
    if api is None:
        api = get_structural_api_hierarchy()
    if ntype is not None:
        return api.get(ntype, [])
    else:
        return api


def get_structural_supertypes(qtype, parents=[]):

    """ Returns in argument 1, the super types of a given type. """

    subtypes = get_structural_subtypes()
    if qtype in subtypes:
        for cand in subtypes:
            children = get_structural_subtypes(cand)
            if qtype in children:
                parent = cand
                if len(parents) < 10:
                    parents.append(parent)
                    get_structural_supertypes(parent, parents)
                    break


def is_schema_message_valid(message, line):

    """ Checks if message is valid to generate an error """

    exclusions = ['DefaultSeverity', 'RulePack', 'MapRule']
    valid = True
    if message is None or message == '':
        valid = False
    if line < 1:
        valid = False
    for exclusion in exclusions:
        if exclusion in message:
            valid = False
            break
    return valid


def validate_schema(xml, errors, debug=False):

    """ Validate Schema, called from SublimeLinter """
    try:
        # TODO: rules.xsd has being manually modified to point to mask-3.2.xsd with full path. Any way to avoid this?
        # Fixed RulePack
        # Commented out RulePackDefinition, ScriptDefinitions  and the following types of rules (and their corresponding rules)
        # <!--                <xs:element ref="InputSetRule" minOccurs="0" maxOccurs="unbounded"/> -->
        # <!--                <xs:element ref="BufferCopyRule" minOccurs="0" maxOccurs="unbounded"/> -->
        # <!--                <xs:element ref="AllocationRule" minOccurs="0" maxOccurs="unbounded"/>  -->
        # <!--                <xs:element ref="StringLengthRule" minOccurs="0" maxOccurs="unbounded"/> -->
        # <!--                <xs:element ref="NonReturningRule" minOccurs="0" maxOccurs="unbounded"/> -->
        # <!--                <xs:element ref="MapRule" minOccurs="0" maxOccurs="unbounded"/> -->
        # <!--                <xs:element ref="ControlflowActionPrototype" minOccurs="0" maxOccurs="unbounded"/> -->
        schema_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, "resources", "rules.xsd")
        mask_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, "resources", "mask-3.2.xsd")
        schema_file = open(schema_path, 'r')
        mask_path = mask_path.replace(' ', '%20')
        mask_path = "file:///" + mask_path
        schema_contents = schema_file.read()
        if os.name == 'nt':
            mask_path = mask_path.replace('\\', '/')
        schema_contents = schema_contents.replace('mask-3.2.xsd', mask_path, 1)
        schema_root = ltree.XML(schema_contents.encode("utf-8"))
        schema_file.close()
        schema = ltree.XMLSchema(schema_root)
        xml = ltree.fromstring(xml.encode("utf-8"))
        schema.validate(xml)
        for line in schema.error_log:
            match = re.match(r'.*:(\d+):(\d+):(.+)', str(line))
            line = int(match.group(1))
            message = match.group(3)
            if is_schema_message_valid(message, line):
                error = {'type': ErrorType.ERROR, 'lineno': line, 'message': message}
                errors.append(error)
    except Exception as error:
        if debug:
            print("Error validating schema: %s" % error)


def check_format_version(rule, errors, debug=True):

    """ Checks the rule format version """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    version_checks_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, os.pardir, os.pardir, "resources", "version_checks.json")
    f = open(version_checks_path, 'r')
    checks = json.loads(f.read())
    language = rule.attrib.get('language', None)
    if "DeprecationRule" in rule.tag:
        return
    origVersion = rule.attrib.get('formatVersion', "0")
    proposedVersion = "3.2"
    message = "Rule version should be " + proposedVersion
    if rule.sourceline > 65535:
        line = rule.sourceline - 1
    else:
        line = rule.sourceline
    try:
        root = ltree.Element("root")
        root.append(deepcopy(rule))
        for check, version in checks.items():
            if len(root.xpath("." + check, namespaces=namespaces)) > 0:
                if StrictVersion(version) > StrictVersion(proposedVersion):
                    proposedVersion = version
                    message = "Rule version should be " + proposedVersion + " [" + check + "]"
        del(root)
        if language == "objc" and origVersion in ["6.10", "6.30"]:
            # Skipping error
            pass
        elif proposedVersion != origVersion and StrictVersion(origVersion) < StrictVersion(proposedVersion):
            error = {'type': ErrorType.ERROR, 'lineno': line, 'message': message}
            errors.append(error)
        elif proposedVersion != origVersion and StrictVersion(origVersion) > StrictVersion(proposedVersion):
            error = {'type': ErrorType.WARNING, 'lineno': line, 'message': message}
            errors.append(error)
    except Exception as e:
        if debug:
            print(e)


def check_description_reference_and_validated_taint_flags(rule, errors, debug=True):

    """ Extracts category and checks if description reference and VALIDATED_XXX taint flags are cohrerent. """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}

    cat = rule.find("./f:VulnCategory", namespaces=namespaces)
    if cat is not None:
        category = str(cat.text)
    else:
        category = None
    subcat = rule.find("./f:VulnSubcategory", namespaces=namespaces)
    if subcat is not None:
        subcategory = str(subcat.text)
    else:
        subcategory = ""

    if category is not None:
        modcat = category.replace(' ','_').replace('(','_').replace(')','_').replace('-','_').upper()
        if subcategory != "":
            modsub = subcategory.replace(' ','_').replace('(','_').replace(')','_').replace('-','_').upper()
            allowed_taintflag = 'VALIDATED_%s_%s' % (modcat, modsub)
            allowed_description = ('.%s_%s' % (modcat, modsub)).lower()
        else:
            allowed_taintflag = 'VALIDATED_%s' % (modcat)
            allowed_description = '.%s' % modcat.lower()

        # Check description ref
        descriptions = rule.findall("./f:Description", namespaces=namespaces)
        for description in descriptions:
            ref = str(description.attrib.get('ref',None))
            ref_suffix = ref[ref.rfind('.'):]
            if ref.endswith("description_not_needed") and category == "Fortify Internal":
                pass
            elif len(ref_suffix) > 0 and allowed_description != ref_suffix:
                line = description.sourceline -1 if description.sourceline > 65535 else description.sourceline
                message = "Review description. Did you mean '%s' instead of '%s'" % (allowed_description, ref_suffix)
                error = {'type': ErrorType.ERROR, 'lineno': line, 'message': message}
                errors.append(error)

        # Check taintflags
        report = True
        tmperrors = []
        TaintFlagSets = rule.findall("./f:Sink//f:TaintFlagSet", namespaces=namespaces)
        for TaintFlagSet in TaintFlagSets:
            taintflag = str(TaintFlagSet.attrib.get('taintFlag',None))
            if allowed_taintflag == taintflag:
                report = False
            if "VALIDATED_" in taintflag and allowed_taintflag != taintflag:
                line = TaintFlagSet.sourceline -1 if TaintFlagSet.sourceline > 65535 else TaintFlagSet.sourceline
                message = "Review validated taint flag check. Did you mean '%s'" % (allowed_taintflag)
                error = {'type': ErrorType.ERROR, 'lineno': line, 'message': message}
                tmperrors.append(error)
        if report:
            for e in tmperrors:
                errors.append(e)

        rule_text = str(ltree.tostring(rule)) #.decode("utf-8"))
        baseline = rule.sourceline
        for index, line in enumerate(rule_text.split("\n")):
            if ":Definition>" in line:
                baseline = rule.sourceline + index
                break
        definition = rule.find("./f:Definition", namespaces=namespaces)
        if definition is not None:
            text = str(definition.text)
            if "VALIDATED_" in text and allowed_taintflag not in text:
                flags = re.findall('(VALIDATED_[A-Z0-9_]+)', text, re.DOTALL)
                for flag in flags:
                    if allowed_taintflag != flag:
                        message = "Review validated taint flag check. Did you mean '%s'" % allowed_taintflag
                        error = {'type': ErrorType.ERROR, 'lineno': baseline + 1, 'message': message}
                        errors.append(error)


def check_wildcard(rule, errors, debug=True):

    """ Parameter tags with a WildCard tag that is not in the last position """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    if rule.tag.replace('{xmlns://www.fortifysoftware.com/schema/rules}', '') == "Parameters":
        for i, child in enumerate(rule):
            if child.tag == "{xmlns://www.fortifysoftware.com/schema/rules}WildCard":
                pass
                if i != len(rule) - 1:
                    message = "WildCard tag is only allowed in the last position"
                    error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
                    errors.append(error)


def is_tag_empty(tag, rule, errors):
    empty = True
    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    for tag in rule.findall(".//f:" + tag, namespaces=namespaces):
        if "" == str(tag.text) or "None" == str(tag.text):
            message = "Empty Element"
            error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
            errors.append(error)


def check_empty_tags(rule, errors, debug=True):

    """ Check for empty tags """

    for tag in ['Group', 'RuleID', 'OutArguments', 'InArguments', 'TaintFlags', 'DefaultSeverity', 'VulnKingdom', 'VulnCategory', 'VulnSubcategory']:
        is_tag_empty(tag, rule, errors)


def check_default_severity(rule, errors, debug=True):

    """ Default Severity should not be 1 """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    default_severity = rule.find("./f:DefaultSeverity", namespaces=namespaces)
    if default_severity is not None:
        if ("1.0" == str(default_severity.text)) or ("1" == str(default_severity.text)):
            ignore = False
            for child in rule:
                if child.tag == "{xmlns://www.fortifysoftware.com/schema/rules}VulnCategory" and str(child.text) == "Fortify Internal":
                    ignore = True
            if not ignore:
                message = "Issues with DefaultSeverirty of 1.0 are not shown in AWB"
                error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
                errors.append(error)


def check_regexps(rule, errors, debug=True):

    """ Check regular-expressions """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    for pattern in rule.findall(".//f:Pattern", namespaces=namespaces):
        if pattern.getparent().tag != "{xmlns://www.fortifysoftware.com/schema/rules}ConstantMatches":
            if re.match(r'^[~a-zA-Z0-9_\.]+$', str(pattern.text)):
                # Should be value
                message = "Pattern tag can be replaced with Value"
                error = {'type': ErrorType.ERROR, 'lineno': pattern.sourceline, 'message': message}
                errors.append(error)
            if re.match(r'^.+[^\\]\$.+$', str(rule.text)):
                message = "Seems like you need to escape the $."
                error = {'type': ErrorType.ERROR, 'lineno': pattern.sourceline, 'message': message}
                errors.append(error)
    for value in rule.findall(".//f:Value", namespaces=namespaces):
        if re.match(r'.*[()|?*\\].*', str(value.text)):
            # Should be Pattern
            message = "Value looks like a regular expression"
            error = {'type': ErrorType.ERROR, 'lineno': value.sourceline, 'message': message}
            errors.append(error)


def check_structural_predicate(rule, errors, structural_vars, debug=True):

    """ Check Structural blocks """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    if re.match(r'(?i).*(Structural|Characterization)Rule$', rule.tag):
        predicate = rule.find("./f:StructuralMatch", namespaces=namespaces)
        if predicate is None:
            predicate = rule.find("./f:Predicate", namespaces=namespaces)
        if predicate is None:
            # Maybe a Returns rule
            return
        rule_text = str(ltree.tostring(rule)) #.decode("utf-8"))
        predicate_text = str(predicate.text)
        baseline = predicate.sourceline - 1
        for index, line in enumerate(rule_text.split("\n")):
            if ":StructuralMatch>" in line or ":Predicate>" in line:
                baseline = rule.sourceline + index
                break
        if predicate is not None:
            validate_structural_predicates(predicate_text, baseline, errors, structural_vars)


def check_definition_tag(rule, errors, structural_vars, debug=True):

    """ Check Definition blocks """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    definition = rule.find("./f:Definition", namespaces=namespaces)
    if definition is not None and len(structural_vars) > 0:
        definition_text = definition.text
        remove_args = re.findall(r'(,\s*\[.*?\])', definition_text, re.S)
        for arg in remove_args:
            definition_text = definition_text.replace(arg, "")
        remove_args = re.findall(r'(,\s*\{.*?\})', definition_text, re.S)
        for arg in remove_args:
            definition_text = definition_text.replace(arg, "")
        foreach_blocks = re.findall(r'(foreach\s+([a-zA-Z0-9-_]+)\s*{(.*)})', definition_text, re.S)
        foreach_vars = []
        for todo, var, block in foreach_blocks:
            foreach_vars.append(var)
            definition_text = definition_text.replace(todo, "")
            oi = block.index('(') + 1
            ci = block.rindex(')')
            all_args_in_foreach = [s.strip() for s in block[oi:ci].split(',')]
            # Find variables in "contains" relations that are missing a "foreach" in the definition block
            for v in structural_vars:
                if v['relation'] == "contains":
                    name = v['name']
                    if name != var:
                        message = "Are you missing a foreach statement for variable %s?" % (name,)
                        error = {'type': ErrorType.ERROR, 'lineno': definition.sourceline, 'message': message}
                        errors.append(error)
            # Find variables used in the definition block that were not defined in the predicate
            for a in all_args_in_foreach:
                var_used = False
                for v in structural_vars:
                    if v['name'] == a:
                        var_used = True
                if not var_used:
                    message = "The foreach block uses a variable (%s) that is not defined in the predicate" % (a)
                    error = {'type': ErrorType.ERROR, 'lineno': definition.sourceline, 'message': message}
                    errors.append(error)
        # Check that all the variables in foreach statements are the last one declared
        plain_structural_vars = [i['name'] for i in structural_vars]
        for fev in foreach_vars:
            if fev in plain_structural_vars and fev not in plain_structural_vars[-1*len(foreach_vars):]:
                message = "The foreach block uses a variable that is defined too early in the predicate."
                error = {'type': ErrorType.ERROR, 'lineno': definition.sourceline, 'message': message}
                errors.append(error)

def check_label_rules(rule, errors, debug=True):

    """ Check Label rules blocks """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    if re.match(r'{xmlns://www\.fortifysoftware\.com/schema/rules}CharacterizationRule', rule.tag):
        definition = rule.find("./f:Definition", namespaces=namespaces)
        if definition is not None and "Label(" in definition.text:
            predicate = rule.find("./f:StructuralMatch", namespaces=namespaces)
            predicate_text = str(predicate.text)
            if re.match(r"^\n*\s*Class", predicate_text):
                message = "Label rules cannot take Class as the topmost element"
                error = {'type': ErrorType.ERROR, 'lineno': definition.sourceline, 'message': message}
                errors.append(error)

def check_controlflow_definition_tag(rule, errors, debug=True):

    """ Check Controlflow blocks """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    if re.match(r'{xmlns://www\.fortifysoftware\.com/schema/rules}ControlflowRule', rule.tag):
        definition = rule.find("./f:Definition", namespaces=namespaces)
        rule_text = str(ltree.tostring(rule)) #.decode("utf-8"))
        ruleVersion = rule.attrib.get('formatVersion', "0")
        baseline = rule.sourceline
        for index, line in enumerate(rule_text.split("\n")):
            if ":Definition>" in line:
                baseline = baseline + index
                break
        if definition is not None:
            validate_controlflow_definitions(str(definition.text), baseline, rule.sourceline, ruleVersion, errors)


def check_package_metainfo(rule, errors, debug=True):

    """ Check that the rule contains a valid package metainfo field [@name='package'] """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    namespace_package_map = {}
    if "DeprecationRule" not in rule.tag:
        if rule.tag != "{xmlns://www.fortifysoftware.com/schema/rules}SuppressionRule":
            package = rule.find("./f:MetaInfo/f:Group[@name='package']", namespaces=namespaces)
            if package is None or package.text == "":
                message = "Please specify a valid package metainfo field"
                error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
                errors.append(error)
            else:
                language = rule.attrib.get('language', None)
                if language != "cfml":
                    # Fill Namespace-Package map
                    ns_v = rule.find("./f:FunctionIdentifier/f:NamespaceName/f:Value", namespaces=namespaces)
                    ns_p = rule.find("./f:FunctionIdentifier/f:NamespaceName/f:Pattern", namespaces=namespaces)
                    ns = ""
                    if ns_v is not None:
                        ns = ns_v.text
                    if ns_p is not None:
                        ns = ns_p.text
                    if ns is not None and ns != "":
                        try:
                            p = namespace_package_map[ns]
                            if p != package.text:
                                message = "The namespace is also defined for a different package [%s]. Are you using the right Package/namespace?" % p
                                error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
                                errors.append(error)
                        except:
                            #print("CAnnot find package for NS %s storing %s"  % (ns,package.text,))
                            namespace_package_map[ns] = package.text


def check_python_version(rule, errors, debug=True):

    """ Rule for Python rules. Check if rules with empty class name are 3.9 """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    if re.match(r'(?i).*Rule$', rule.tag):
        version = rule.attrib.get('formatVersion', None)
        language = rule.attrib.get('language', None)
        if language == "python":
            e = rule.find("./f:FunctionIdentifier", namespaces=namespaces)
            if e:
                classname_v = rule.find("./f:FunctionIdentifier/f:ClassName/f:Value", namespaces=namespaces)
                classname_p = rule.find("./f:FunctionIdentifier/f:ClassName/f:Pattern", namespaces=namespaces)
                if classname_v:
                    classname_v = classname_v.text
                if classname_p:
                    classname_p = classname_p.text
                if classname_p is None and classname_v is None:
                    if version != "3.9" and version != "3.12":
                        message = "Global function rules can be safely downgraded to 3.9 version"
                        error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
                        errors.append(error)


def check_applyto_tag(rule, errors, debug=True):

    """ Check that rules with a classname contains a Applyto tag """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    if rule.tag == "{xmlns://www.fortifysoftware.com/schema/rules}FunctionIdentifier":
        classname_v = rule.find("./f:ClassName/f:Value", namespaces=namespaces)
        classname_p = rule.find("./f:ClassName/f:Pattern", namespaces=namespaces)
        if classname_v:
            classname_v = classname_v.text
        if classname_p:
            classname_p = classname_p.text
        if classname_p or classname_v:
            applyto = rule.find("./f:ApplyTo", namespaces=namespaces)
            if applyto is None:
                message = "Please add a valid ApplyTo tag"
                error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
                errors.append(error)
        if classname_p is None and classname_v is None:
            applyto = rule.find("./f:ApplyTo", namespaces=namespaces)
            if applyto:
                message = "Looks like a global function, is ApplyTo tag needed?"
                error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
                errors.append(error)


def check_inputsource(rule, errors, debug=True):

    """ Check that entrypoint rules contain InputSource metainfo """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    if re.match(r'{xmlns://www\.fortifysoftware\.com/schema/rules}Dataflow(EntryPoint|Source)Rule', rule.tag):
        inputsource = rule.find("./f:MetaInfo/f:Group[@name='inputsource']", namespaces=namespaces)
        if inputsource == "" or inputsource is None:
            message = "Please specify a valid inputSource metainfo field"
            error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
            errors.append(error)
        else:
            source = inputsource.text
            source = source.replace('XML', 'Xml')
            source = source.replace('URL', 'Url')
            source = source.replace('JSON', 'Json')
            source = source.replace('GUI', 'Gui')
            source = source.replace('JavaScript', 'Javascript')
            if not source.istitle():
                message = "Inputsource should be TitleCase"
                error = {'type': ErrorType.WARNING, 'lineno': inputsource.sourceline, 'message': message}
                errors.append(error)

    if re.match(r'{xmlns://www\.fortifysoftware\.com/schema/rules}CharacterizationRule', rule.tag):
        definition = rule.find("./f:Definition", namespaces=namespaces)
        inputsource = rule.find("./f:MetaInfo/f:Group[@name='inputsource']", namespaces=namespaces)
        if (inputsource is None and definition is not None):
            if "TaintSource" in str(definition.text) or "TaintWrite" in str(definition.text) or "TaintEntrypoint" in str(definition.text):
                message = "Please specify a valid inputSource metainfo field"
                error = {'type': ErrorType.ERROR, 'lineno': rule.sourceline, 'message': message}
                errors.append(error)


def check_cdata(rule, errors, debug=True):

    """ Check that characterization and structural rules use CDATA blocks """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    if re.match(r'{xmlns://www\.fortifysoftware\.com/schema/rules}CharacterizationRule', rule.tag):
        definition = rule.find("./f:Definition", namespaces=namespaces)
        if definition:
            if not ("<![CDATA[" in str(ltree.tostring(definition)) and "]]>" in str(ltree.tostring(definition))):
                message = "Please enclose it within a CDATA block"
                error = {'type': ErrorType.ERROR, 'lineno': definition.sourceline, 'message': message}
                errors.append(error)
        structuralMatch = rule.find("./f:StructuralMatch", namespaces=namespaces)
        if structuralMatch:
            if not ("<![CDATA[" in str(ltree.tostring(structuralMatch)) and "]]>" in str(ltree.tostring(structuralMatch))):
                message = "Please enclose it within a CDATA block"
                error = {'type': ErrorType.ERROR, 'lineno': structuralMatch.sourceline, 'message': message}
                errors.append(error)
    if re.match(r'{xmlns://www\.fortifysoftware\.com/schema/rules}StructuralRule', rule.tag):
        predicate = rule.find("./f:Predicate", namespaces=namespaces)
        if not ("<![CDATA[" in str(ltree.tostring(predicate)) and "]]>" in str(ltree.tostring(predicate))):
            message = "Please enclose it within a CDATA block"
            error = {'type': ErrorType.ERROR, 'lineno': predicate.sourceline, 'message': message}
            errors.append(error)


def check_php_sensitiveness(rule, errors, debug=True):

    """ PHP case sensitiveness """

    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    language = rule.attrib.get('language', None)
    if language == "php":
        values = rule.findall(".//f:Value", namespaces=namespaces)
        for value in values:
            case = value.get('caseInsensitive')
            if case != "true" and case != "True":
                message = 'For PHP please specify caseInsensitive="true"'
                error = {'type': ErrorType.ERROR, 'lineno': value.sourceline, 'message': message}
                errors.append(error)
        patterns = rule.findall(".//f:Pattern", namespaces=namespaces)
        for pattern in patterns:
            case = pattern.get('caseInsensitive')
            if case != "true" and case != "True":
                message = 'For PHP please specify caseInsensitive="true"'
                error = {'type': ErrorType.ERROR, 'lineno': pattern.sourceline, 'message': message}
                errors.append(error)


def validate_rules(xml, errors, debug=True):

    """ Validate rules, called from SublimeLinter """

    try:
        category = ""
        subcategory = ""

        context = ltree.iterparse(BytesIO(xml.encode('utf-8')), strip_cdata=False)
        for action, elem in context:
            if re.match(r'(?i).*Rule$', elem.tag):
                rule = elem
                check_format_version(rule, errors, debug)
                check_description_reference_and_validated_taint_flags(rule, errors, debug)
                check_wildcard(rule, errors, debug)
                check_empty_tags(rule, errors, debug)
                check_regexps(rule, errors, debug)
                structural_vars = []
                check_structural_predicate(rule, errors, structural_vars, debug)
                check_definition_tag(rule, errors, structural_vars, debug)
                check_label_rules(rule, errors, debug)
                check_controlflow_definition_tag(rule, errors, debug)
                check_package_metainfo(rule, errors, debug)
                check_python_version(rule, errors, debug)
                check_applyto_tag(rule, errors, debug)
                check_inputsource(rule, errors, debug)
                check_php_sensitiveness(rule, errors, debug)

    except ltree.XMLSyntaxError as e:
        if debug:
            print("Error validating rules: %s" % e)
        row = int(re.search(r',\sline\s(\d*)', e.msg).group(1))
        if row > 0:
            error = {'type': ErrorType.ERROR, 'lineno': row, 'message': e.msg}
            errors.append(error)


def extract_predicate_vars(node):

    """ Extract predicate variables """

    global rulevars
    get_vars_list(node, rulevars)


def validate_structural_predicates(block, baseline, errors, array_vars=[]):

    """ Validates controlflow definition blocks and generate linter errors, called from SublimeLinter """

    try:
        # Parse structural block and generate AST
        lexer.lineno = 0
        ast = parser.parse(block, lexer=lexer)
        process_ast(ast)

        # Search for duplicated variables
        names = []
        for v in rulevars:
            names.append(v[0])
        duplicates = [x for x, y in collections.Counter(names).items() if y > 1]
        for v in rulevars:
            if v[0] in duplicates:
                message = 'Variable "' + v[0] + '" is declared more than once, rule format version >= 3.4 must use unique variable name'
                error = {'type': ErrorType.ERROR, 'lineno': baseline + v[1], 'message': message }
                errors.append(error)

        # Process references errors
        scanAST(ast, errors, baseline, array_vars)

        # Look for patters that should not be used
        def collect(node):
            return [node]
        expanded_ast = expand_references(ast, debug=False)

        results = []
        search('FunctionCall.function', expanded_ast, callback=collect, results=results)
        if len(results) > 0:
            message = 'Use FunctionCall.possibleTargets instead of FunctionCall.funcion'
            error = {'type': ErrorType.WARNING, 'lineno': baseline + 1, 'message': message}
            errors.append(error)

        results = []
        search('Expression.constantValue', expanded_ast, callback=collect, results=results)
        if len(results) > 0:
            message = 'Use Expression.constantValues instead of Expression.constantValue'
            error = {'type': ErrorType.WARNING, 'lineno': baseline + 1, 'message': message}
            errors.append(error)

        results = []
        search('Construct.enclosingClass.name', expanded_ast, callback=collect, results=results)
        if len(results) > 0:
            message = 'Account for super classes'
            error = {'type': ErrorType.WARNING, 'lineno': baseline + 1, 'message': message}
            errors.append(error)

        results_static_types = []
        search('Expression.type', expanded_ast, callback=collect, results=results_static_types)
        results_dynamic_types = []
        search('Expression.reachingTypes', expanded_ast, callback=collect, results=results_dynamic_types)
        if len(results_static_types) > 0 and len(results_dynamic_types) == 0:
            message = 'Add Expression.reachingTypes to complete Expression.type with SCA derived types'
            error = {'type': ErrorType.WARNING, 'lineno': baseline + 1, 'message': message}
            errors.append(error)

    except SyntaxError as e:
        lines = block.split('\n')
        output = []
        if re.match(r'^\s*$', lines[0]):
            del lines[0]
        if re.match(r'^\s*$', lines[-1]):
            del lines[-1]
        block = "\n".join(lines)
        message = 'Syntax error in Structural block'
        error = {'type': ErrorType.ERROR, 'lineno': baseline+1, 'length': len(block), 'message': message}
        errors.append(error)


def get_complete_suggestions(block):

    """ Called from completion plugins, it finds out the position of the cursor, finds a reference and returns a list of properties """

    try:
        # Parse structural block and generate AST
        lexer.lineno = 0
        node = parser.parse(block, lexer=lexer)
        process_ast(node)

        # Process references errors
        result = []
        get_suggestions(node, result)
        if len(result) > 0:
            return result[0]
        else:
            return []
    except SyntaxError as e:
       print("Syntax error in line " + str(e.args))


def validate_controlflow_definitions(block, baseline, ruleline, version, errors):

    """ Validates controlflow definition blocks and generate linter errors, called from SublimeLinter """

    # Process line MetaInfo
    lines = []
    for m in re.finditer(r'.*\n', block):
        lines.append(m.end())
    # Process state declarations
    for d in re.finditer(r'state\s+([a-zA-Z0-9-_]+)\s*(start|error)?\s*(:)?.*;', block):
        try:
            declaration = d.group(0)
            if ":" in declaration and StrictVersion(version) < StrictVersion("3.4"):
                message = 'Controlflow rules using state descriptions should use at least version 3.4'
                error = {'type': ErrorType.ERROR, 'lineno': ruleline, 'message': message}
                errors.append(error)
            elif ":" in declaration:
                for i, e in enumerate(errors):
                    if e['lineno'] == ruleline:
                        e0 = re.match(r'Rule version should be (\d+\.\d+)', e['message'])
                        if e0:
                            if StrictVersion(e0.group(1)) < StrictVersion("3.4"):
                                del(errors[i])
        except:
            message = 'Invalid FormatVersion'
            error = {'type': ErrorType.ERROR, 'lineno': ruleline, 'message': message}
            errors.append(error)
    # Process state transitions
    for t in re.finditer(r'{(.*)}', block):
        transition = t.group(1)
        transition_line = baseline
        for i in range(len(lines)):
            if lines[i] > t.start(1):
                transition_line = i + baseline
                break
        # Process function dereference with no $
        for m in re.finditer(r'\s*[a-zA-Z0-9-_]+\.([a-zA-Z0-9-_]+)\(', transition):
            result = m.group(1)
            message = 'FunctionIdentifier "' + result + '" dereference is missing a $ sign'
            error = {'type': ErrorType.ERROR, 'lineno': transition_line, 'message': message}
            errors.append(error)


def process_ast(node, level=0, printAST=False, extractRuleVars=True):

    """ Loops the AST tree and assign parent-child references. It also can print the tree if printAST is true """

    # Extract variables
    global rulevars
    if level == 0 and extractRuleVars:
        rulevars = []
        extract_predicate_vars(node)

    if node:
        if node.leaf and printAST:
            print("|  "*level + "|--" + str(node.type) + " (" + str(node.leaf) + ") ")
        elif printAST:
            print("|  "*level + "|--" + str(node.type))
        level += 1
        for child in node.children:
            child.parent = node
            process_ast(child, level, printAST, extractRuleVars=False)

def print_ast(node):

    """ Print a structural language AST """

    process_ast(node, level=0, printAST=True, extractRuleVars=False)

def get_suggestions(node, result):

    """ Given the root AST node, it starts parsing till it finds a AUTOCOMPLETE REFERENCE. Then it finds out the type and returns a list of property for this type """

    if node:
        # Complete subrule types. eg: fc.function is [COMPLETE]
        if node.type == "subrule" and str(node.children[0].leaf) == "Complete":
            if node.parent.type == "relation":
                if node.parent.children[0].type == "reference":
                    reftype = get_reference_type(node.parent.children[0])
                    expectedtype = reftype.replace("[]","")
                    stypes = get_structural_subtypes(expectedtype)
                    stypes.append(expectedtype)
                    #print("Options are " + str(stypes))
                    results = []
                    for stype in stypes:
                        #results.append((stype + ": ", "", stype + " Type"))
                        results.append((stype, "", stype + " Type"))
                    result.append(results)
        # Complete references
        elif node.type == "reference" and re.match(r'.*COMPLETE.*', node.leaf):
            typerule = node
            while True:
                if typerule.parent.type == "relation":
                    return
                if typerule.parent.type == "rule" or typerule.parent.type == "subrule":
                    if typerule.parent.children[0].type == "type":
                        # If there is a type declaration in the subrule, get the type from there. eg [Class: ] or [Class c:]
                        typename = typerule.parent.children[0].leaf
                    else:
                        # Support for shorthand syntax. eg: fc.function is [constructor and name == "test"]
                        # We have to go up to the subrule assignment and get the reference type of the lhs of the assignment
                        # print("[+] parent type " + typerule.parent.type)
                        if typerule.parent.type == "subrule":
                            #print("[+] grandparent type " + typerule.parent.parent.type)
                            if typerule.parent.parent.type == "relation":
                                goal = typerule.parent.parent.children[0]
                                reftype = get_reference_type(goal)
                                if reftype:
                                    #print("[+] Final type " + res1[0])
                                    shorthandSyntax = True
                                    typename = reftype

                    #print("[+] type: " + str(typename))

                    if len(typerule.parent.children[0].children) > 0:
                        varname = typerule.parent.children[0].children[0].leaf
                    else:
                        varname = None
                    reference = node.leaf
                    if varname and reference.startswith(varname + "."):
                        reference = reference.replace(varname + ".", "")
                    if varname and reference == varname:
                        reference = ""
                    break
                else:
                    typerule = typerule.parent
            index = reference.index("COMPLETE")
            reference = reference[0:index]
            reference = reference.strip('.')
            reference = typename + "." + reference
            bits = reference.split('.')
            # print("Searching final type for " + typename)
            for i, bit in enumerate(bits):
                if i + 1 < len(bits):
                    prop = bits[i + 1]
                    if prop.endswith("]"):
                        prop = prop[0:prop.index("[")]
                    if typename.endswith("[]"):
                        typename = typename[0:typename.index("[")]
                    props = []
                    try:
                        props = get_structural_properties(typename)
                    except:
                        pass
                    # print("Getting all properties of " + typename + ": " + str(props) )
                    found = False
                    for (pname, ptype, pdesc) in props:
                        if pname == prop:
                            # print("Property " + prop + " is a valid property for " + typename + " now, moving to " + ptype)
                            typename = ptype
                            found = True
                            break
                    if not found:
                        # If the part not found is the name of other variable
                        for (vname, vline, vtype) in rulevars:
                            if bits[i + 1] == vname:
                                typename = vtype
                                break
            if typename.endswith("[]"):
                typename = "Array"
            try:
                result.append(get_structural_properties(typename))
            except:
                pass
        else:
            for child in node.children:
                # print("Node: " + node.name)
                get_suggestions(child, result)


def scanAST(node, errors, baseline, array_vars=[]):

    """ Scans the AST tree for errors """

    if node is not None:
        if node.type == "type":
            if not node.leaf in get_structural_properties():
                message = 'Are you sure [' + node.leaf + '] is a valid type ??? Go home you are dunk ..'
                error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                errors.append(error)
        # Check errors in references
        if node.type == "reference":
            typerule = node
            shorthandSyntax = False
            while True:
                if typerule.parent.type == "rule" or typerule.parent.type == "subrule":
                    typename = typerule.parent.children[0].leaf
                    if typename is None or typename not in get_structural_properties():
                        # Support for shorthand syntax. eg: fc.function is [constructor and name == "test"]
                        # We have to go up to the subrule assignment and get the reference type of the lhs of the assignment
                        # print("[+] parent type " + typerule.parent.type)
                        if typerule.parent.type == "subrule":
                            #print("[+] grandparent type " + typerule.parent.parent.type)
                            if typerule.parent.parent.type == "relation":
                                goal = typerule.parent.parent.children[0]
                                reftype = get_reference_type(goal)
                                if reftype:
                                    #print("[+] Final type " + res1[0])
                                    shorthandSyntax = True
                                    typename = reftype
                    if typename is None:
                        break
                    reference = node.leaf

                    if shorthandSyntax or len(typerule.parent.children[0].children) == 0:
                        varname = None
                    else:
                        varname = typerule.parent.children[0].children[0].leaf


                    if varname and reference.startswith(varname + "."):
                        reference = reference.replace(varname + ".", "", 1)
                    if varname and reference == varname:
                        reference = ""
                    if reference.endswith('.'):
                        message = 'Incomplete reference "' + reference + '"'
                        error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                        errors.append(error)
                    validate_reference(typename + "." + reference, errors,  baseline + node.line)
                    break
                else:
                    typerule = typerule.parent
        # Check relation errors
        elif node.type == "relation":
            if node.leaf == "contains":
                if len(node.children) == 2:
                    if node.children[0].type == "reference":
                        lhs_type = get_reference_type(node.children[0])
                        if lhs_type:
                            typename = lhs_type
                            if not typename.endswith("[]") and not typename in ["Function", "Class", "Statement", "CallStatement", "ReturnStatement", "ThrowStatement", "AssignmentStatement", "IfStatement", "WhileStatement", "DeclStatement", "Block", "TryBlock", "CatchBlock", "FinallyBlock", "SynchronizedBlock", "SwitchBlock", "AsmBlock" ] :
                                message = 'Comparing a single element with a collection ' + typename
                                print(message)
                                error = {'type': ErrorType.ERROR, 'lineno': baseline + node.children[0].line, 'message': message}
                                errors.append(error)
                            elif typename.endswith("[]"):
                                typename = typename.replace("[]","")
                                try:
                                    subt = get_structural_subtypes(typename)
                                except:
                                    subt = []
                                if not typename in subt:
                                    subt.append(typename)
                                typefound = ""
                                rhs_type = str(node.children[1].type)
                                if rhs_type == "subrule":
                                    if node.children[1].children[0].type == "type":
                                        # Subrule contains a type declaration. eg: fc.function is [Function: constructor]
                                        if len(node.children[1].children[0].children) > 0:
                                            var_name = str(node.children[1].children[0].children[0].leaf)
                                            array_vars.append({"name": var_name, "relation": "contains"})
                                        typefound = str(node.children[1].children[0].leaf)
                                    else:
                                        # Support for shorthand syntax. eg fc.function is [constructor or name == "matches"]
                                        typefound = typename
                                elif rhs_type == "reference":
                                    typefound = get_reference_type(node.children[1])
                                if (typefound == "" or typefound is None) and "String" == typename:
                                    # eg: labels contains "foo"
                                    pass
                                elif not typefound in subt and not typename in get_structural_subtypes(typefound):
                                    message = 'Expecting "' + str(subt) + '" but found "' + typefound + '"'
                                    error = {'type': ErrorType.ERROR, 'lineno': baseline + node.children[0].line, 'message': message}
                                    errors.append(error)

            elif node.leaf in ["is", "==", "==="]:
                if len(node.children) == 2:
                    if node.children[0].type == "reference":
                        lhs_type = get_reference_type(node.children[0])
                        if lhs_type:
                            typename = lhs_type
                            if typename.endswith("[]") and not re.match(r'.*\[\d+\]$', node.children[0].leaf):
                                message = 'Comparing a collection with a single element'
                                error = {'type': ErrorType.ERROR, 'lineno': baseline + node.children[0].line, 'message': message}
                                errors.append(error)
                                return
                            elif typename.endswith("[]"):
                                typename = typename.replace("[]","")
                            subt = deepcopy(get_structural_subtypes(typename))
                            if not typename in subt:
                                subt.append(typename)
                            rhs_value = str(node.children[1].leaf)
                            rhs_type = str(node.children[1].type)
                            typefound = rhs_type
                            if str(rhs_type) == "subrule":
                                if node.children[1].children[0].type == "type":
                                    # Subrule contains a type declaration. eg: fc.funcion is [Function: constructor]
                                    if len(node.children[1].children[0].children) > 0:
                                        var_name = str(node.children[1].children[0].children[0].leaf)
                                        array_vars.append({"name": var_name, "relation": "is"})
                                    typefound = str(node.children[1].children[0].leaf)
                                elif node.children[1].children[0].type in ["relation", "reference"]:
                                    # Support for shorthand syntax. eg fc.function is [constructor or name == "matches"]
                                    typefound = typename
                                else:
                                    pass
                                    #print("[-] Error: Cannot determine main type of subrule")
                            elif rhs_type == "reference":
                                typefound = get_reference_type(node.children[1])
                            elif re.match(r'\d+', rhs_value):
                                typefound = "int"
                            elif re.match(r'\".*\"', rhs_value):
                                typefound = "Identifier"
                            if typefound is not None and typefound.endswith("[]"):
                                typefound = typefound.replace("[]","")
                            if typefound is not None and not typefound in subt and not typename in get_structural_subtypes(typefound):
                                if (typename == "String" and typefound == "" and '"' in rhs_value) or (typename == "Identifier" and typefound == "" and '"' in rhs_value) or (typename == "Boolean" and (rhs_value == "true" or rhs_value == "false")):
                                    pass
                                if typename == "Type" and typefound == "typeliteral":
                                    pass
                                elif (typename == "Boolean" and rhs_value != "true" and rhs_value != "false"):
                                    message = 'Expecting "' + str(subt) + '" but found something else: "' + rhs_value + '"'
                                    error = {'type': ErrorType.ERROR, 'lineno': baseline + node.children[0].line, 'message': message}
                                    errors.append(error)
                                elif ((typename == "String" or typename == "Identifier") and typefound == "" and '"' in rhs_value):
                                    message = 'Expecting "' + str(subt) + '" but found something else: "' + rhs_value + '"'
                                    error = {'type': ErrorType.ERROR, 'lineno': baseline + node.children[0].line, 'message': message}
                                    errors.append(error)
                                else:
                                    message = 'Expecting "' + str(subt) + '" but found "' + typefound + '"'
                                    error = {'type': ErrorType.ERROR, 'lineno': baseline + node.children[0].line, 'message': message}
                                    errors.append(error)
            # Regular Expression checks
            if node.leaf == "matches":
                if len(node.children) == 2:
                    if node.children[1].type == "literal":
                        literal = node.children[1].leaf
                        if (literal.startswith('"') and literal.endswith('"')) or (literal.startswith("'") and literal.endswith("'")):
                            literal = literal[1:-1]
                        if re.match(r'^[a-zA-Z0-9\.]+$', literal):
                            # Should be value
                            message = "It looks like you are using a regular expression to match a literal value"
                            error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                            errors.append(error)
            elif node.leaf in ["==", "==="]:
                if len(node.children) == 2:
                    if node.children[1].type == "literal":
                        literal = str(node.children[1].leaf)
                        if (literal.startswith('"') and literal.endswith('"')) or (literal.startswith("'") and literal.endswith("'")):
                            literal = literal[1:-1]
                        if re.match(r'.*(\(|\)|\||\.\*).*', literal):
                            # Should be Pattern
                            message = "It looks like you are using regular operator with a regular expression"
                            error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                            errors.append(error)

            # T"type" checks
            if node.leaf in ["matches", "==", "==="]:
                if len(node.children) == 2:
                    reftype = get_reference_type(node.children[0])
                    if reftype and reftype is not "":
                        lhstypename = reftype
                        if lhstypename == "Type":
                            reftype = get_reference_type(node.children[1])
                            # Check if it is compared with another Type
                            if reftype:
                                rhstypename = reftype
                                # print(lhstypename + " compared with " + rhstypename)
                                if lhstypename != rhstypename:
                                    message = "Type should be compared with Type or literal"
                                    error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                                    errors.append(error)
                            # Check if its compared with a literal that is not a type literal (T)
                            elif node.children[1].type == "literal":
                                literal = node.children[1].leaf
                                if node.leaf == "matches":
                                    message = "The matches relation can only be used to compare Strings."
                                    error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                                    errors.append(error)
                                elif node.leaf in ["==", "==="]:
                                    message = "Cannot compare types Type and String with operator '=='."
                                    error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                                    errors.append(error)
                            elif node.children[1].type != "typeliteral":
                                message = "Type should be compared with Type or type literal(T)"
                                error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                                errors.append(error)

            # Matches relation should only be used with strings
            if node.leaf == "matches":
                try:
                    reftype_lhs = get_reference_type(node.children[0])
                    reftype_rhs = get_reference_type(node.children[1])
                    if reftype_lhs:
                        lhstypename = reftype_lhs
                        if lhstypename not in ["Value", "String", "Identifier"]:
                            message = "The matches relation can only be used to compare Strings."
                            error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                            errors.append(error)
                    if reftype_rhs:
                        rhstypename = reftype_rhs
                        if rhstypename not in ["String", "Identifier"]:
                            message = "The matches relation can only be used to compare Strings."
                            error = {'type': ErrorType.ERROR, 'lineno': baseline + node.line, 'message': message}
                            errors.append(error)
                except:
                    pass


        for child in node.children:
            scanAST(child, errors, baseline, array_vars)


def get_reference_root_type(node):

    """ Given a reference node, it returns the name of the root type """

    if node:
        if node.type == "reference":
            typerule = node
            while True:
                if typerule.parent.type == "rule" or typerule.parent.type == "subrule":
                    typename = typerule.parent.children[0].leaf
                    if typename is None:
                        # Support for shorthand syntax. eg: fc.function is [constructor and name == "test"]
                        # We have to go up to the subrule assignment and get the reference type of the lhs of the assignment
                        # print("[+] parent type " + typerule.parent.type)
                        if typerule.parent.type == "subrule":
                            #print("[+] grandparent type " + typerule.parent.parent.type)
                            if typerule.parent.parent.type == "relation":
                                goal = typerule.parent.parent.children[0]
                                typename = get_reference_type(goal)
                    if typename is None:
                        #print("[+] None typename at node line: " + str(node.line) + " reference " + node.leaf)
                        break

                    # Check if there is a variable access
                    if len(typerule.parent.children[0].children) > 0:
                        varname = typerule.parent.children[0].children[0].leaf
                    else:
                        varname = None

                    reference = node.leaf

                    # remove var names from reference
                    if varname and reference.startswith(varname + "."):
                        reference = reference.replace(varname + ".", "", 1)
                    if varname and reference == varname:
                        reference = ""

                    # Is there an outer variable access?
                    first_element = reference.split('.')[0]
                    for (vname, vline, vtype) in rulevars:
                        if first_element == vname:
                            typename = vtype
                            #print ("'%s' found in rule vars" % (first_element,))

                    break
                else:
                    # Keep on looking
                    typerule = typerule.parent

            if typename is not None and reference is not None:
                return (typename, reference) 
    return (None, None)


def get_reference_type(node):

    """ Given a reference node, find out the final type """

    if node:
        if node.type == "reference":
            (typename, reference) = get_reference_root_type(node)
            if typename is not None and reference is not None:
                reference = typename + "." + reference
                chunks = reference.split('.')
                #print("Find type starting with " + typename + " for reference " + reference)
                for i, chunk in enumerate(chunks):
                    #print(i,chunk)
                    if i + 1 < len(chunks):
                        if typename.endswith("[]"):
                            if None is chunks[i + 1]:
                                typename = typename[0:typename.index('[')]
                            else:
                                #print(chunks[i])
                                if "[" in chunks[i]:
                                    typename = typename[0:typename.index('[')]
                                else:
                                    typename = "Array"
                        prop = chunks[i + 1]
                        if "[" in prop:
                            prop = prop[0:prop.index('[')]
                        try:
                            props = get_structural_properties(typename)
                        except:
                            print("Exception in get_reference_type")
                            return None 
                        found = False
                        for (pname, ptype, pdesc) in props:
                            if pname == prop:
                                #print("    Prop OK: " + pname)
                                typename = ptype
                                #print("    New type: " + str(ptype))
                                found = True
                                break
                        if not found:
                            # If the part not found is the name of other variable
                            #print("'%s' not found in '%s' properties" % (prop, typename,))
                            for (vname, vline, vtype) in rulevars:
                                if chunks[i + 1] == vname:
                                    #print ("'%s' found in rule vars" % (prop,))
                                    typename = vtype
                                    #print("Found type (with rule var): " + typename, reference)
                                    return typename
                #print("Found type: " + typename, reference)
                return typename 
        else:
            for child in node.children:
                return get_reference_type(child)


def validate_reference(reference, errors, line):

    """ Given a reference, it finds out the root type and parse from there to check that all sub-references are valid """

    reference = reference.strip('.')
    # print("Validate reference: " + reference)
    bits = reference.split('.')
    typename = bits[0]

    arrayElement = False
    for i, bit in enumerate(bits):
        if i + 1 < len(bits):
            previousArrayElement = arrayElement
            prop = bits[i + 1]
            # In case it is a index reference annotations[0]
            try:
                # print("prop " + prop)
                index =  prop.index("[")
                if index > 0:
                    arrayElement = True
                else:
                    arrayElement = False
                prop = prop[0:index]
            except:
                print("Exception in validate_reference")
                pass

            # if typename.endswith("[]") and not previousArrayElement:
            #     typename = "Array"
            # elif typename.endswith("[]") and previousArrayElement:
            #     typename = typename[0:typename.index("[")]

            isArray = False
            if typename.endswith("[]"):
                typename = typename[0:typename.index("[")]
                isArray = True
            try:
                props = get_structural_properties(typename)
            except:
                message = 'Cannot validate reference ' + reference + ' because type ' + typename + ' is unknown'
                error = {'type': ErrorType.ERROR, 'lineno': line, 'message': message}
                errors.append(error)
                break
            if isArray:
                props += get_structural_properties('Array')

            # if array:
                # props = [("length","int","Length of the array")]
            # print("Properties of " + typename + " are " + str(props))
            found = False
            for (pname, ptype, pdesc) in props:
                if pname == prop:
                    # print("    Prop: " + pname + " type: " + str(ptype))
                    typename = ptype
                    # print("    New type: " + str(ptype))
                    found = True
                    break
            if not found:
                # If the part not found is the name of other variable
                isRefVar = False
                for (vname, vline, vtype) in rulevars:
                    if prop == vname:
                        typename = vtype
                        isRefVar = True
                        break
                # print('    ERROR: "' + prop + '" is not a property of type ' + type + '.')
                if not isRefVar and prop != "null":
                    message = '"' + prop + '" is not a property of type ' + typename + '.'
                    error = {'type': ErrorType.ERROR, 'lineno': line, 'message': message}
                    errors.append(error)


def get_props_for_type(api_root, type):

    """ Given the API XML doc and a Type, this function searches the XML structural reference and returns all the properties for the given type """

    props = []
    type_elems = api_root.xpath('./Section/Head[text()="' + str(type) + '"]')
    if len(type_elems) > 0:
        # Properties are defined in Section thats the second sibling for Head
        section = type_elems[0].getnext().getnext()
        if section is not None:
            prop_elems = section.xpath('./List/Item/Bold')
            for p in prop_elems:
                prop_type = p.getnext().text[1:-1]
                prop_desc = p.getnext().tail.replace(':', '').strip().replace("'", '"')
                # print(prop_desc)
                props.append((p.text, prop_type, prop_desc))
    else:
        type_elems = api_root.xpath('./Section/Head[text()="' + str(type) + ' (internal)"]')
        if len(type_elems) > 0:
            # Properties are defined in Section thats the second sibling for Head
            section = type_elems[0].getnext().getnext()
            if section is not None:
                prop_elems = section.xpath('./List/Item/Bold')
                for p in prop_elems:
                    prop_type = p.getnext().text[1:-1]
                    prop_desc = p.getnext().tail.replace(':', '').strip()
                    # print(prop_desc)
                    props.append((p.text, prop_type, prop_desc))
    return props


def expand_references(node, level=0, debug=False):

    """ Loops the AST tree and assign parent-child references. It also can print how it is expanding the tree if debug is true """

    if node:
        if node.leaf:
            if debug:
                print("|  "*level + "|--" + node.type + " (" + node.leaf + ") ")
            # Expand reference nodes. AST equivalent to replacing enclosingClass.supers contains [Class:] 
            # for enclosingClass is [Class: supers contains [Class: ]]
            if node.type == "reference" and "." in node.leaf:

                elements = node.leaf.split('.')
                for (vname, vline, vtype) in rulevars:
                    if elements[0] == vname and len(elements) == 2:
                        # Nothing to do here, its a outer var dereference with just one chunk in the remaining_reference (eg: fc.instance), no need to expand it.
                        return

                # Get the type of the root element (after discarding possible variable dereferences)
                (root_type_name, reference) = get_reference_root_type(node)

                if debug:
                    print("--------------------------------------")
                    print (">>>", node.leaf, root_type_name, reference)
                if "." in reference:
                    props = get_structural_properties(root_type_name)
                    chunks = reference.split('.')
                    chunk = chunks[0]
                    outer_varname = None
                    for (vname, vline, vtype) in rulevars:
                        if chunk == vname:
                            # Shift right to ignore outer variable name
                            try:
                                outer_varname = chunks[0]
                                chunks = chunks[1:]
                                chunk = chunks[0]
                            except:
                                print("Error unwrapping reference")
                                print(rulevars, chunks)
                    remaining_reference = ".".join(chunks[1:])
                    remaining_node = Node('reference', 0, None, remaining_reference)
                    remaining_reference_type = get_reference_type(node)
                    remaining_reference_isarray = False
                    # print("Chunk: " + chunk)
                    # print("Remaining reference: " + remaining_reference)
                    # print("Remaining reference type: " + remaining_reference_type)
                    if "[]" in remaining_reference_type:
                        remaining_reference_isarray = True
                        remaining_reference_type = remaining_reference_type.replace("[]","")
                    chunk_type = None
                    chunk_isarray = False
                    found = False
                    for (pname, ptype, pdesc) in props:
                        if chunk == pname:
                            found = True
                            if "[]" in ptype:
                                chunk_isarray = True
                                ptype = ptype.replace("[]","")
                            chunk_type = ptype
                            props = get_structural_properties(ptype)
                        if found:
                            break
                    if outer_varname:
                        chunk = outer_varname + "." + chunk 
                    # print("Chunk: ", chunk,  str(chunk_type))
                    # If we find the type for the root element of the reference and for the final type of the reference, generate AST nodes
                    if chunk_type and remaining_reference_type:
                        parent = node.parent
                        idx = parent.children.index(node)
                        try:
                            sibling = parent.children[idx + 1]
                        except:
                            try:
                                sibling = parent.children[idx + 1]
                            except:
                                sibling = None

                        chunk_relation = "contains" if chunk_isarray else "is"
                        remaining_reference_relation = "contains" if remaining_reference_isarray else "is"

                        new_node = None
                        if sibling is not None and parent.type == "relation":
                            if sibling.type == "subrule" and remaining_reference != "":
                                # |  |  |  |  |  |--relation (contains)
                                # |  |  |  |  |  |  |--reference (enclosingClass.supers) <----
                                # |  |  |  |  |  |  |--subrule
                                # |  |  |  |  |  |  |  |--type (Class)
                                # |  |  |  |  |  |  |  |--relation (matches)
                                # |  |  |  |  |  |  |  |  |--reference (name)
                                # |  |  |  |  |  |  |  |  |--literal ("(Foundation\.)?(NS)?URLSession")

                                new_node = Node("relation", children=[
                                    Node("reference", leaf=chunk),
                                    Node("subrule", children=[
                                        Node("type", leaf=chunk_type),
                                        Node("relation", children=[
                                            Node("reference", leaf=remaining_reference),
                                            Node("subrule", children=node.parent.children[1].children)
                                        ], leaf=remaining_reference_relation)
                                    ])
                                ], leaf=chunk_relation, parent=node.parent)
                            elif sibling.type == "literal":
                                # |  |  |--relation (matches)
                                # |  |  |  |--reference (variable.name)
                                # |  |  |  |--literal ("kSec(Foo|Bar)")
                                #            vvvvvvv
                                # |  |  |--relation (is)
                                # |  |  |  |--reference (variable)
                                # |  |  |  |--subrule
                                # |  |  |  |  |--type (Variable)
                                # |  |  |  |  |--relation (matches)
                                # |  |  |  |  |  |--reference (name)
                                # |  |  |  |  |  |--literal ("kStr(Foo|Bar)")

                                new_node = Node("relation", children=[
                                    Node("reference", leaf=chunk),
                                    Node("subrule", children=[
                                        Node("type", leaf=chunk_type),
                                        Node("relation", children=[
                                            Node("reference", leaf=remaining_reference),
                                            Node("literal", children=[], leaf=sibling.leaf)
                                        ], leaf=node.parent.leaf)
                                    ])
                                ], leaf=chunk_relation, parent=node.parent)
                            elif sibling.type == "reference":
                                # |--relation (is)
                                # |  |--reference (fc.arguments[0])
                                # |  |--subrule
                                # |  |  |--type (FunctionCall)
                                # |  |  |--relation (==)
                                # |  |  |  |--reference (function.name)
                                # |  |  |  |--reference (file4.name)

                                new_node = Node("relation", children=[
                                    Node("reference", leaf=chunk),
                                    Node("subrule", children=[
                                        Node("type", leaf=chunk_type),
                                        Node("relation", children=[
                                            Node("reference", leaf=remaining_reference),
                                            Node("reference", children=[], leaf=sibling.leaf)
                                        ], leaf=node.parent.leaf)
                                    ])
                                ], leaf=chunk_relation, parent=node.parent)
                            if new_node is not None:
                                # Process new node in order to expand the rest of references
                                if debug:
                                    print("+++", new_node.type, new_node.leaf, ' in ', node.parent.parent.type, node.parent.parent.leaf)
                                new_node = expand_references(new_node, level, debug=debug)
                                # Add new node with expanded reference
                                node.parent.parent.children.append(new_node)
                                # Remove old node (containing the reference)
                                if debug:
                                    print("---", node.parent.type, node.parent.leaf)
                                    print_ast(node.parent)
                                if debug:
                                    print("--------------------------------------")
                                node.parent.parent.children.remove(node.parent)
                        elif sibling is None:
                            # |--and
                            # |  |--relation (is)
                            # |  |  |--reference (instance)
                            # |  |  |--subrule
                            # |  |  |  |--type (Expression)
                            # |  |  |  |--reference (constantValue.null) <--- 
                            # |  |--relation (is)
                            # |  |  |--reference (instance)
                            # |  |  |--subrule
                            # |  |  |  |--type (Expression)
                            # |  |  |  |--relation (is)
                            # |  |  |  |  |--reference (constantValue)
                            # |  |  |  |  |--subrule
                            # |  |  |  |  |  |--type (Value)
                            # |  |  |  |  |  |--literal (null)

                            if remaining_reference == "null":
                                remaining_node = Node("literal", children=[], leaf="null")
                            else:
                                remaining_node = Node("reference", children=[], leaf=remaining_reference)

                            new_node = Node("relation", children=[
                                Node("reference", leaf=chunk),
                                Node("subrule", children=[
                                    Node("type", leaf=chunk_type),
                                    remaining_node
                                ])
                            ], leaf=chunk_relation, parent=node.parent)

                            if new_node is not None:
                                # Process new node in order to expand the rest of references
                                if debug:
                                    print("+++", new_node.type, new_node.leaf, ' in ', node.parent.parent.type, node.parent.parent.leaf)
                                new_node = expand_references(new_node, level, debug=debug)
                                # Add new node with expanded reference
                                node.parent.children.append(new_node)
                                # Remove old node (containing the reference)
                                if debug:
                                    print("---", node.parent.type, node.parent.leaf)
                                    print_ast(node.parent)
                                if debug:
                                    print("--------------------------------------")
                                node.parent.children.remove(node)
                        elif parent.type in ["and", "or"]:
                            new_node = None
                            if sibling.type == "not":

                                new_node = Node("relation", children=[
                                    Node("reference", leaf=chunk),
                                    Node("subrule", children=[
                                        Node("type", leaf=chunk_type),
                                        Node("reference", leaf=remaining_reference)
                                    ], leaf=node.parent.leaf)
                                ], leaf=chunk_relation, parent=node.parent)
                            if new_node is not None:
                                # Process new node in order to expand the rest of references
                                if debug:
                                    print("+++", new_node.type, new_node.leaf, ' in ', node.parent.parent.type, node.parent.parent.leaf)
                                new_node = expand_references(new_node, level, debug=debug)
                                # Add new node with expanded reference
                                node.parent.children.append(new_node)
                                # Remove old node (containing the reference)
                                if debug:
                                    print("---", node.parent.type, node.parent.leaf)
                                    print_ast(node.parent)
                                if debug:
                                    print("--------------------------------------")
                                node.parent.children.remove(node)

                        else:
                            print("Error, reference compared with unhandled type %s" % sibling.type)
                            print_ast(node.parent.parent)
                            sys.exit(-1)

        elif debug:
            print("|  " * level + "|--" + node.type + " c(" + str(len(node.children)) + ")")

        level += 1

        for child in reversed(node.children):
            child.parent = node
            expand_references(child, level, debug)

        process_ast(node, level=0, printAST=False, extractRuleVars=False)
        return node



def collect_references(node, references=[]):

    """ Get all the references related with a type node """

    # |--rule
    # |  |--type (FunctionCall)
    # |  |--and <-------- node to collect references
    # |  |  |--relation (is)
    # |  |  |  |--reference (constantValue)
    # |  |  |  |--literal ("foo")
    # |  |  |--and
    # |  |  |  |--relation (is)
    # |  |  |  |  |--reference (function)
    # |  |  |  |  |--subrule <----- do not propagate to subrules
    # |  |  |  |  |  |--type (Function)
    # |  |  |  |--relation (is)
    # |  |  |  |  |--reference (enclosingClass)
    # |  |  |  |  |--subrule <---- do not propagate to subrules
    # |  |  |  |  |  |--type (Class)
    # |  |  |  |  |  |--relation (==)
    # |  |  |  |  |  |  |--reference (name)
    # |  |  |  |  |  |  |--literal ("foo")
    for child in node.children:
        if child.type == "reference":
            references.append(child)
        elif child.type != "subrule":
            collect_references(child, references)


def search(str_query, node, callback=None, results=[]):

    """ Search the ast for a reference chain that matches the query.  If found call callback() with parent of reference node and return callback results in passed results array. Callback must returs a list """

    items = str_query.split(".")
    qtype = items[0]
    query = items[1:]
    search_internal(qtype, query, node, callback, results)

def search_internal(qtype, query, node, callback=None, results=[]):

    """ Search the AST for a reference chain that matches the query.  If found call callback() with parent of reference node and return callback results in passed results array. Callback must returs a list """

    if node:
        # Find all "type" nodes that matches the query type (qtype)
        # For each finding, get the longest reference chain from the type node and check the query list against resulting reference chain
        if node.type == 'type':
            parents = [node.leaf]
            get_structural_supertypes(node.leaf, parents)
            if qtype in parents:
                try:
                    sibling = node.parent.children[1]
                    #print_ast(sibling)
                    references = []
                    collect_references(sibling, references)
                    #print("")
                    for ref in references:
                        #print_ast(ref)
                        reference_chain = []
                        get_reference_chain(ref, reference_chain)
                        result = match_reference_chain(query, reference_chain)
                        if result is not None and callback is not None:
                            processed = callback(result)
                            if processed is not None:
                                results += processed
                except:
                    print("Exception in search_internal")
                    pass

        # Find all outer variable references. eg: FunctionCall fc: function is [Function: fc.name == "Foo"]
        elif node.type == "reference":
            if "." in node.leaf:
                varname = node.leaf.split(".")[0]
                for (vname, vline, vtype) in rulevars:
                    if vname == varname:
                        if qtype == vtype:
                            rule_node = deepcopy(node) 
                            while True:
                                rule_node = rule_node.parent
                                if rule_node.type in ["rule", "subrule"]:
                                    break
                            #print_ast(rule_node)

                            # set rule node type to var type
                            rule_node.children[0].leaf = vtype
                            # set rule node var name varname if it has a different name. 
                            if len(rule_node.children) > 0:
                                if len(rule_node.children[0].children) > 0:
                                    rule_node.children[0].children[0].leaf = varname 

                            def search_outer_var(node, varname):
                                if node.type == "reference" and varname in node.leaf:
                                    node.leaf = node.leaf.replace(varname, "") 
                                    return
                                else:
                                    for child in node.children:
                                        search_outer_var(child, varname)
                            search_outer_var(rule_node, varname + ".")

                            #print_ast(rule_node)

                            references = []
                            collect_references(rule_node, references)
                            for ref in references:
                                reference_chain = []
                                get_reference_chain(ref, reference_chain)
                                # for c in reference_chain:
                                #     print_ast(c)
                                result = match_reference_chain(query, reference_chain)
                                if result is not None and callback is not None:
                                    processed = callback(result)
                                    if processed is not None:
                                        results += processed

        for child in node.children:
            search_internal(qtype, query, child, callback, results)


def get_reference_chain(node, reference_chain=[]):

    """ Given a root node, descende the tree and collect all references, creating a reference chain. Resulting reference chain is returned in argument 1 (chain) """

    if node is not None:
        if node.type == "reference":
            reference_chain.append(node)
            if len(node.parent.children) > 1:
                sibling = node.parent.children[1]
                if len(sibling.children) > 1:
                    n = sibling.children[1]
                    if len(n.children) > 0:
                        next_reference = n.children[0]
                        get_reference_chain(next_reference, reference_chain)


def match_reference_chain(query, reference_chain):

    """ Checks if a given reference chain satisafy a query Reference chain contains reference nodes, so we need to compare their leaf properties with the query items. If query matches, it returns the reference parent node """

    if len(reference_chain) >= len(query):
        found = True
        for i, (qitem, rnode) in enumerate(zip(query, reference_chain[:len(query)])):
            if qitem != rnode.leaf:
                found = False
                break
        if found:
            # Return the parent of the reference node
            return reference_chain[i].parent

class RulepackLinter:

    def run(self, code, maxlimit=1000000, debug=False):
        if maxlimit > 0 and len(code) > maxlimit:
            print("Rulepack to big to lint. Modify LimiterMaxChar if you want it linted no matter how")
            exit(0)
        else:
            #code = code.decode("utf8")
            errors = []
            validate_rules(code, errors, debug)
            validate_schema(code, errors, debug)
            error_str = ''
            for err in errors:
                if err['type'] == "error":
                    error_str += "E:"
                elif err['type'] == "warning":
                    error_str += "W:"
                error_str += os.path.abspath(argv[1]) + ":"
                error_str += str(err['lineno']) + ":"
                if "colno" in err:
                    error_str += str(err['colno']) + ": "
                else:
                    error_str += "0: "
                error_str += err['message']
                error_str += "\n"

            error_str = error_str.rstrip()
            print(error_str)
            exit(0)


if __name__ == '__main__':
    if len(argv) < 2:
        exit(-1)
    f = open(argv[1])
    code = f.read()
    f.close()
    linter = RulepackLinter()
    limit = 1000000
    if len(argv) > 2:
        limit = argv[2]
    debug = False
    if len(argv) > 3:
        if argv[3] == "debug":
            debug = True
    linter.run(code, limit, debug)
