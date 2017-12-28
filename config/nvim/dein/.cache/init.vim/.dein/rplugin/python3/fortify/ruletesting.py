# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import os
import os.path
import json
import re
import tempfile
import ntpath
import shutil

class Common(object):

    vim = None

    def status_message(self, msg):
        self.vim.command('redraw | echo "%s"' % msg)

    def list2str(self, l):
        s = "["
        for i in l:
            s += "'" + str(i).replace("'", "\'") + "', "
        return s[:-2] + "]"

class ScanUtils(Common):

    build_id = ''
    fpr_name = ''
    tmpdir = ''
    t = None
    p = None
    tree = None
    ix = None
    count = 0
    addend = 1
    size = 8
    message = "Scanning"

    def check_scan(self):
        res = self.p.poll()
        if res is None:
            before = self.count % self.size
            after = (self.size - 1) - before

            if self.rules_path != "":
                self.status_message('%s %s%s (using: %s) [%s=%s]' % (self.message, self.build_id, '*' if self.properties else '',self.rules_path,' ' * before, ' ' * after))
            else:
                self.status_message('%s %s%s [%s=%s]' % (self.message, self.build_id, '*' if self.properties else '', ' ' * before, ' ' * after))

            if not after:
                self.addend = -1
            if not before:
                self.addend = 1
            self.count += self.addend
            return None
        else:
            self.done = True
            self.count = 0
            self.status_message("")
            result, err = self.p.communicate()
            return result

class ScanCommand(ScanUtils):

    def __init__(self, vim):
        self.vim = vim

    def load_build_id(self, build_id):
        build_id_map_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, "resources", "build_ids.json")
        try:
            f = open(build_id_map_path, "r")
            map = json.loads(f.read())
            f.close()
            return map.get(build_id, "/tmp")
        except:
            return "/tmp"


    def run(self, build_id, rules_path, structural_dump=False, generate_fvdl=False, validate_rules=False, scan_nsts=False):
        self.rules_path = rules_path
        self.build_id = build_id
        self.path =  self.load_build_id(self.build_id)
        self.commands = []
        self.properties = False

        # Rule validation
        if rules_path != "" and rules_path is not None and validate_rules is True:
            cmd = ['sourceanalyzer', '-validate-rules', '-rules', self.rules_path]
            self.message = "Validating rules"
            self.commands.append(cmd)

            cmds = "["
            for cmd in self.commands:
                cmds = cmds + self.list2str(cmd) + ", "
            cmds = cmds[:-2] + "]"
            self.vim.command("let g:fortify_message = '%s %s'" % (self.message, ntpath.basename(self.rules_path)))
            self.vim.command("let g:fortify_commandlist = %s" % cmds)
            self.vim.command("call fortify#OpenTestPaneWindow()")
            self.vim.command("call fortify#ClearTestPaneWindow()")
            self.vim.command("call g:fortify#InvokeChainedCommandsHandler('', '', '')")
            self.vim.command('let g:fortify_fprpath = "%s"' % self.fpr_name)
            return

        if self.build_id != "" and self.build_id is not None:

            # Support for scanning a directory containing NSTs
            if (scan_nsts and os.path.isdir(build_id)):
                nst_dir = build_id
                nst_files = [os.path.join(nst_dir, f) for f in os.listdir(nst_dir) if os.path.isfile(os.path.join(nst_dir, f))]
                buildid_opts = nst_files
            else:
                buildid_opts = ['-b', build_id]

            # Get scan settings from plugin settings
            memory_opts = self.vim.eval("g:fortify_MemoryOpts")
            scan_opts = self.vim.eval("g:fortify_ScanOpts")

            if os.path.isfile(os.path.join(self.path,"sca.properties")):
                try:
                    f = open(os.path.join(self.path,"sca.properties"), "r")
                    props = json.loads(f.read())
                    memory_opts = props.get("MemoryOpts", memory_opts)
                    scan_opts = props.get("ScanOpts", scan_opts)
                    self.properties = True
                    f.close()
                except:
                    self.status_message("Could not load SCA properties. Problem parsing JSON file")

            # Get system temp directory
            self.tmpdir = os.path.join(tempfile.gettempdir(), 'vim-fortify')
            if os.path.exists(self.tmpdir):
                shutil.rmtree(self.tmpdir)
            os.makedirs(self.tmpdir)
            self.fpr_name = os.path.join(self.tmpdir, 'scan.fpr')

            # Print SCA version
            cmd0 = ['sourceanalyzer', '-v']
            self.commands.append(cmd0)

            if len(buildid_opts) > 0 and buildid_opts is not None and self.fpr_name != "" and self.fpr_name is not None:
                default_rules_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, os.pardir, os.pardir, "rules", 'default-rules.xml')
                if self.rules_path is not None:
                    param_list = ['sourceanalyzer', '-scan', '-f', self.fpr_name, '-rules', self.rules_path, '-rules', default_rules_path]
                else:
                    param_list = ['sourceanalyzer', '-scan', '-f', self.fpr_name, '-rules', default_rules_path]

                if structural_dump:
                    cmd1 = param_list + memory_opts + scan_opts + ["-Ddebug.dump-structural-tree=true"] + buildid_opts
                else:
                    cmd1 = param_list + memory_opts + scan_opts + buildid_opts

                self.commands.append(cmd1)

                if not structural_dump:
                    if generate_fvdl:
                        cmd2 = ["run_tests_and_generate_fvdl"]
                    else:
                        cmd2 = ["run_tests"]
                    self.commands.append(cmd2)

                cmds = "["
                for cmd in self.commands:
                    cmds = cmds + self.list2str(cmd) + ", "
                cmds = cmds[:-2] + "]"
                if self.rules_path != "" and self.rules_path is not None:
                    self.vim.command("let g:fortify_message = '%s %s%s (using: %s)'" % (self.message, self.build_id, '*' if self.properties else '', ntpath.basename(self.rules_path)))
                else:
                    self.vim.command("let g:fortify_message = '%s %s%s'" % (self.message, self.build_id, '*' if self.properties else ''))
                self.vim.command("let g:fortify_commandlist = %s" % cmds)
                self.vim.command("call fortify#OpenTestPaneWindow()")
                self.vim.command("call fortify#ClearTestPaneWindow()")
                self.vim.command("call g:fortify#InvokeChainedCommandsHandler('', '', '')")
                self.vim.command('let g:fortify_fprpath = "%s"' % self.fpr_name)
                return

        self.status_message("Oops, something went wrong")

class TranslateUtils(Common):
    build_id = ""
    t = None
    p = None
    count = 0
    addend = 1
    size = 8
    message = "Translating"
    result = ""

    def persist_build_id(self, build_id, path):
        try:
            build_id_map_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir, "resources", "build_ids.json")
            f = open(build_id_map_path, "r")
            map = json.loads(f.read())
            f.close()
            map[build_id] = path
            f = open(build_id_map_path, "w")
            f.write(json.dumps(map))
            f.close()
        except:
            pass

    def check_translate(self):
        res = self.p.poll()
        if res is None:
            before = self.count % self.size
            after = (self.size - 1) - before
            self.status_message('%s %s%s (mode: %s) [%s=%s]' % (self.message, self.build_id, '*' if self.properties else '', self.mode,' ' * before, ' ' * after))
            if not after:
                self.addend = -1
            if not before:
                self.addend = 1
            self.count += self.addend
        else:
            poutput, err = self.p.communicate()
            if poutput is not None:
                self.result += poutput + "\n"
            self.done = True

class TranslateFileCommand(TranslateUtils):

    def __init__(self, vim):
        self.vim = vim

    def run(self, filepath, build_id=None):
        self.path = ntpath.dirname(filepath)
        self.mode = "file"
        filename = ntpath.basename(filepath)
        self.properties = False
        self.commands = []
        if build_id is None:
            self.build_id = ntpath.splitext(filename)[0].replace(' ', '_')
        else:
            self.build_id = build_id
        self.persist_build_id(self.build_id, self.path)
        if self.build_id != "" and self.build_id is not None:
            memory_opts = self.vim.eval("g:fortify_MemoryOpts")
            translation_opts = self.vim.eval("g:fortify_TranslationOpts")
            jdk_version = self.vim.eval("g:fortify_JDKVersion")
            ccompiler = self.vim.eval("g:fortify_CCompiler")
            cppcompiler = self.vim.eval("g:fortify_CPPCompiler")
            compiler_options = self.vim.eval("g:fortify_CompilerOptions")
            xcodesdk = self.vim.eval("g:fortify_XCodeSDK")
            if os.path.isfile(os.path.join(self.path,"sca.properties")):
                try:
                    f = open(os.path.join(self.path,"sca.properties"), "r")
                    props = json.loads(f.read())
                    memory_opts = props.get("MemoryOpts", memory_opts)
                    translation_opts = props.get("TranslationOpts", translation_opts)
                    jdk_version = props.get("JDKVersion", jdk_version)
                    self.properties = True
                    f.close()
                except:
                    self.status_message("Could not load SCA properties. Problem parsing JSON file")
            cmd0 = ['sourceanalyzer', '-v']
            self.commands.append(cmd0)
            cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
            self.commands.append(cmd1)
            cmd2 = ['sourceanalyzer', '-b', self.build_id]
            if len(memory_opts) > 0:
                cmd2 += memory_opts
            if len(translation_opts) > 0:
                cmd2 += translation_opts

            # Extensions with special needs
            remove_binary = False
            if filename.endswith(".py"):
                python_path = self.vim.eval("g:fortify_PythonPath")
                if python_path is not None:
                    cmd2.append('-python-path')
                    cmd2.append(python_path)
            elif filename.endswith(".java") and len(jdk_version) > 0:
                cmd2.append('-source')
                cmd2.append(jdk_version)
            elif filename.endswith(".c"):
                cmd2.append(ccompiler)
                cmd2 += compiler_options.split(' ')
            elif filename.endswith(".cpp"):
                cmd2.append(cppcompiler)
                cmd2 += compiler_options.split(' ')
            elif filename.endswith(".swift"):
                cmd2.append('swiftc')
                cmd2.append('-sdk')
                cmd2.append(xcodesdk)
                cmd2.append('-target')
                cmd2.append('x86_64-apple-ios10.0')
                cmd2.append('-o')
                cmd2.append(os.path.join(self.path,"ftfy.remove"))
                remove_binary = True
            elif filename.endswith(".m"):
                cmd2.append('clang')
                cmd2.append('-c')
                cmd2.append('-mios-simulator-version-min=10.0')
                cmd2.append('-fobjc-abi-version=2')
                cmd2.append('-isysroot')
                cmd2.append(xcodesdk)
                cmd2.append('-framework')
                cmd2.append('Foundation')
                cmd2.append('-framework')
                cmd2.append('UIKit')
                cmd2.append('-o')
                cmd2.append(os.path.join(self.path,"ftfy.remove"))
                remove_binary = True

            cmd2 += [filepath]

            self.commands.append(cmd2)

            if remove_binary:
                cmd3 = ['rm', '-rf', os.path.join(self.path,"ftfy.remove")]
                self.commands.append(cmd3)

            cmds = "["
            for cmd in self.commands:
                cmds = cmds + self.list2str(cmd) + ", "
            cmds = cmds[:-2] + "]"
            self.vim.command("let g:fortify_message = '%s %s%s (mode: %s)'" % (self.message, self.build_id, '*' if self.properties else '', self.mode))
            self.vim.command("let g:fortify_commandlist = %s" % cmds)
            self.vim.command("call fortify#OpenTestPaneWindow()")
            self.vim.command("call fortify#ClearTestPaneWindow()")
            self.vim.command("call g:fortify#InvokeChainedCommandsHandler('', '', '')")
            self.vim.command("let g:fortify_buildid = '%s'" % (self.build_id))
        else:
            self.status_message("Cannot find file to translate")

class TranslateProjectCommand(TranslateUtils):

    def __init__(self, vim):
        self.vim = vim

    def run(self, dir_path, mode="all", build_id=None):
        if dir_path.endswith("/"):
            dir_path = dir_path[:-1]
        dirname = ntpath.basename(dir_path)
        self.mode = mode
        self.path = dir_path
        self.properties = False
        self.commands = []
        if build_id is None:
            try:
                self.build_id = dirname.replace(' ', '_')[0:dirname.index('.xcodeproj')]
            except:
                self.build_id = dirname.replace(' ', '_')
        else:
            self.build_id = build_id
        self.persist_build_id(self.build_id, self.path)
        cmd0 = ['sourceanalyzer', '-v']
        self.commands.append(cmd0)
        if self.build_id != "" and self.build_id is not None:
            memory_opts = self.vim.eval("g:fortify_MemoryOpts")
            translation_opts = self.vim.eval("g:fortify_TranslationOpts")
            jdk_version = self.vim.eval("g:fortify_JDKVersion")
            if os.path.isfile(os.path.join(dir_path,"sca.properties")):
                try:
                    f = open(os.path.join(dir_path,"sca.properties"), "r")
                    props = json.loads(f.read())
                    memory_opts = props.get("MemoryOpts", memory_opts)
                    translation_opts = props.get("TranslationOpts", translation_opts)
                    jdk_version = props.get("JDKVersion", jdk_version)
                    self.properties = True
                    f.close()
                except:
                    self.status_message("Could not load SCA properties. Problem parsing JSON file")
            if mode == "all":
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                cmd2 = ['sourceanalyzer', '-b', self.build_id]
                if len(memory_opts) > 0:
                    cmd2 += memory_opts
                if len(translation_opts) > 0:
                    cmd2 += translation_opts
                if len(jdk_version) > 0:
                    cmd2.append('-source')
                    cmd2.append(jdk_version)
                cmd2 += [self.path]
                self.commands.append(cmd2)
            elif mode == "java" or mode == "android":
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                jars = self.path + "/**/*.jar"
                cmd2 = ['sourceanalyzer', '-b', self.build_id, '-cp', jars]
                default_jar_path = self.vim.eval("g:fortify_DefaultJarPath")
                if default_jar_path != "":
                    cmd2.append("-cp")
                    cmd2.append(os.path.join(default_jar_path, '**', '*.jar'))
                android_jar_path = self.vim.eval("g:fortify_AndroidJarPath")
                if mode == "android" and android_jar_path != "":
                    cmd2.append("-cp")
                    cmd2.append(android_jar_path)
                if len(memory_opts) > 0:
                    cmd2 += memory_opts
                if len(translation_opts) > 0:
                    cmd2 += translation_opts
                if len(jdk_version) > 0:
                    cmd2.append('-source')
                    cmd2.append(jdk_version)
                cmd2 += [self.path]
                self.commands.append(cmd2)
            elif mode == "xcode":
                xcode_build_opts = self.vim.eval("g:fortify_XCodeBuildOpts")
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                cmd2 = ['sourceanalyzer', '-b', self.build_id]
                if len(memory_opts) > 0:
                    cmd2 += memory_opts
                if len(translation_opts) > 0:
                    cmd2 += translation_opts
                cmd2 += ['xcodebuild', 'clean', 'build', '-project', dir_path, '-sdk', 'iphonesimulator']
                if len(xcode_build_opts) > 0:
                    cmd2 += xcode_build_opts
                self.commands.append(cmd2)
                cmd3 = ['sourceanalyzer', '-b', self.build_id, '**/*plist']
                self.commands.append(cmd3)
            elif mode == "python":
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                python_path = self.vim.eval("g:fortify_PythonPath")
                cmd2 = ['sourceanalyzer', '-b', self.build_id]
                cmd2.append('-python-path')
                cmd2.append(python_path)
                if len(memory_opts) > 0:
                    cmd2 += memory_opts
                if len(translation_opts) > 0:
                    cmd2 += translation_opts
                cmd2 += [self.path]
                self.commands.append(cmd2)
            elif mode == "script":
                cmd1 = []
                if os.name == 'nt':
                    cmd1.append(os.path.join(self.path, 'translate.bat'))
                else:
                    cmd1.append(os.path.join(self.path, 'translate.sh'))
                self.commands.append(cmd1)
            elif mode == "dotnet":
                solution_file = None
                for filename in os.listdir(dir_path):
                    if filename.endswith(".sln"):
                        solution_file = os.path.join(dir_path, filename)
                        break
                if solution_file != None:
                    cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                    self.commands.append(cmd1)
                    cmd2 = ['sourceanalyzer', '-b', self.build_id]
                    if len(memory_opts) > 0:
                        cmd2 += memory_opts
                    if len(translation_opts) > 0:
                        cmd2 += translation_opts
                    cmd2 += ['devenv', solution_file, '/REBUILD', 'debug']
                    self.commands.append(cmd2)
            elif mode == "make":
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                cmd2 = ['sourceanalyzer', '-b', self.build_id]
                if len(memory_opts) > 0:
                    cmd2 += memory_opts
                if len(translation_opts) > 0:
                    cmd2 += translation_opts
                cmd2 += ['make', '-C', dir_path, 'clean', 'all']
                self.commands.append(cmd2)
            elif mode == "make_clean_all":
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                cmd2 = ['sourceanalyzer', '-b', self.build_id]
                if len(memory_opts) > 0:
                    cmd2 += memory_opts
                if len(translation_opts) > 0:
                    cmd2 += translation_opts
                cmd2 += ['make', '-C', dir_path, 'clean', 'all']
                self.commands.append(cmd2)
            elif mode == "make_clean":
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                cmd2 = ['sourceanalyzer', '-b', self.build_id]
                if len(memory_opts) > 0:
                    cmd2 += memory_opts
                if len(translation_opts) > 0:
                    cmd2 += translation_opts
                cmd2 += ['make', '-C', dir_path, 'clean']
                self.commands.append(cmd2)
            elif mode == "make_all":
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                cmd2 = ['sourceanalyzer', '-b', self.build_id]
                if len(memory_opts) > 0:
                    cmd2 += memory_opts
                if len(translation_opts) > 0:
                    cmd2 += translation_opts
                cmd2 += ['make', '-C', dir_path, 'clean']
                self.commands.append(cmd2)
            elif mode == "maven":
                cmd1 = ['sourceanalyzer', '-b', self.build_id, '-clean']
                self.commands.append(cmd1)
                if os.path.isdir(os.path.join(self.path, 'src', 'main', 'webapp')):
                    cmd3 = ['sourceanalyzer', '-b', self.build_id, '-cp', '"**/*jar"']
                    if len(memory_opts) > 0:
                        cmd3 += memory_opts
                    if len(translation_opts) > 0:
                        cmd3 += translation_opts
                    if len(jdk_version) > 0:
                        cmd3.append('-source')
                        cmd3.append(jdk_version)
                    cmd3 += [os.path.join(self.path, 'src', 'main', 'webapp')]
                    self.commands.append(cmd3)
                if os.path.isdir(os.path.join(self.path, 'src', 'main', 'resources')):
                    cmd4 = [
                        'sourceanalyzer', '-b', self.build_id, '-cp', '"**/*jar"']
                    if len(memory_opts) > 0:
                        cmd4 += memory_opts
                    if len(translation_opts) > 0:
                        cmd4 += translation_opts
                    if len(jdk_version) > 0:
                        cmd4.append('-source')
                        cmd4.append(jdk_version)
                    cmd4 += [
                        os.path.join(self.path, 'src', 'main', 'resources')]
                    self.commands.append(cmd4)
                cmd2 = [
                    'mvn', '-Dfortify.sca.verbose=true', '-Dmaven.test.skip=true', '-Dfortify.sca.tests.exclude=true',
                    '-Dfortify.sca.debug=false', '-Dfortify.sca.buildId=' + self.build_id, 'com.fortify.ps.maven.plugin:maven-sca-plugin:3.50:translate']
                for opt in memory_opts:
                    if opt == "-64":
                        cmd2.append('-Dfortify.sca.64bit=true')
                    if re.match(r'^-Xmx', opt):
                        cmd2.append(opt.replace('-Xmx', '-Dfortify.sca.Xmx='))
                if len(jdk_version) > 0:
                    cmd2 += ['-Dfortify.sca.source.version=' + jdk_version]
                self.commands.append(cmd2)

            # Yay, asynchronous support!!
            cmds = "["
            for cmd in self.commands:
                cmds = cmds + self.list2str(cmd) + ", "
            cmds = cmds[:-2] + "]"
            self.vim.command("let g:fortify_message = '%s %s%s (mode: %s)'" % (self.message, self.build_id, '*' if self.properties else '', self.mode))
            self.vim.command("let g:fortify_commandlist = %s" % cmds)
            self.vim.command("call fortify#OpenTestPaneWindow()")
            self.vim.command("call fortify#ClearTestPaneWindow()")
            self.vim.command("call g:fortify#InvokeChainedCommandsHandler('', '', '')")
            self.vim.command("let g:fortify_buildid = '%s'" % (self.build_id))
            return
        else:
            self.status_message('Folder name cannot be used as Build Id')

