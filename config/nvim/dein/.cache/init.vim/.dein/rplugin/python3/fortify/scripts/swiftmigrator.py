#!/usr/local/bin/python
from __future__ import print_function

# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import os, sys, inspect
currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)
from linter import *
import exrex
import re
import itertools
import tempfile
import shlex
from subprocess import Popen, PIPE


def translate_swift_signature(function):
    results = []
    function = function.replace('^','')
    if function[-1] == ":":
        function = function[:-1]
    if function.startswith("init") and ":" in function:
        function = function.replace(":", "(", 1)
        function = function + ":)"
        results.append(function)
    elif ":" in function:
        function = function.replace(":", "(_:", 1)
        function = function + ":)"
        results.append(function)
    elif function.startswith("set"):
        function = function[3:]
        function = function[0].lower() + function[1:]
        results.append(function)
    else:
        # if name does not contains ":", it can be a property getter or a funcion with one argument so we need to add a new variant
        results.append(function + "(_:)")
        results.append(function)
    return results

def process_rules(xml):
    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    context = ltree.iterparse(BytesIO(xml.encode('utf-8')), strip_cdata=False)
    for action, elem in context:
        if re.match(r'(?i).*(Structural|Characterization)Rule$', elem.tag):
            language = elem.attrib.get('language', None)
            ruleid = elem.find("./f:RuleID", namespaces=namespaces)
            predicate = elem.find("./f:StructuralMatch", namespaces=namespaces)
            if predicate is None:
                predicate = elem.find("./f:Predicate", namespaces=namespaces)
            if predicate is not None:
                rule = str(ltree.tostring(elem).decode("utf-8"))
                baseline = elem.sourceline
                for index, line in enumerate(rule.split("\n")):
                    if ":StructuralMatch>" in line or ":Predicate>" in line:
                        baseline = elem.sourceline + index
                        break
                process_structural_block(str(predicate.text), str(ruleid.text), baseline)
            else:
                print("    Returns rule??")
        elif re.match(r'(?i).*Dataflow(Sink|Source|Cleanse|Passthrough)Rule$', elem.tag):
            language = elem.attrib.get('language', None)
            ruleid = str(elem.find("./f:RuleID", namespaces=namespaces).text)
            namespace = None
            clss = None
            function = None

            expand_namespace = False
            namespace_elem = elem.find("./f:FunctionIdentifier/f:NamespaceName/f:Value", namespaces=namespaces)
            if namespace_elem is None:
                namespace_elem = elem.find("./f:FunctionIdentifier/f:NamespaceName/f:Pattern", namespaces=namespaces)
                expand_namespace = True
            if namespace_elem is not None:
                namespace = str(namespace_elem.text)

            expand_classname = False
            class_elem = elem.find("./f:FunctionIdentifier/f:ClassName/f:Value", namespaces=namespaces)
            if class_elem is None:
                class_elem = elem.find("./f:FunctionIdentifier/f:ClassName/f:Pattern", namespaces=namespaces)
                expand_classname = True
            if class_elem is not None:
                clss = str(class_elem.text)

            expand_functionname = False
            function_elem = elem.find("./f:FunctionIdentifier/f:FunctionName/f:Value", namespaces=namespaces)
            if function_elem is None:
                function_elem = elem.find("./f:FunctionIdentifier/f:FunctionName/f:Pattern", namespaces=namespaces)
                expand_functionname = True
            if function_elem is not None:
                function = str(function_elem.text)
            process_function_identifier(ruleid, namespace, clss, function, expand_namespace, expand_classname, expand_functionname)

def get_renamed_function(namespace, clss, function):
    code = "import %s\n" % namespace
    code += "%s.%s\n" % (clss, function)
    fp = tempfile.NamedTemporaryFile(delete=False, suffix=".swift")
    fp.write(code)
    fp.close()
    cmd = "swiftc -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk -target x86_64-apple-ios9.0 %s" % fp.name
    process = Popen(shlex.split(cmd), stdout=PIPE, stderr=PIPE)
    (output, err) = process.communicate()
    exitcode = process.returncode
    new_function = function
    #print(code)
    #print(err)
    for line in err.split("\n"):
        if "renamed" in line:
            m = re.match(r".*'(.*)' has been renamed to '(.*)'.*", line)
            if m is not None and m.groups() > 1:
                new_function = m.group(2)
        elif "unresolved identifier" in line:
            m = re.match(r".* use of unresolved identifier '(.*)'.*", line)
            if m is not None and m.groups() > 1:
                invalid_name = m.group(1)
                new_function = 'UNRESOLVED IDENTIFIER: ' + invalid_name
        elif "has no member" in line:
            m = re.match(r".* has no member '(.*)'.*", line)
            if m is not None and m.groups() > 1:
                invalid_name = m.group(1)
                new_function = 'INVALID MEMBER: ' + invalid_name
        elif "missing argument for parameter" in line:
            new_function = 'INCORRECT ARGUMENTS'
        elif "no such module" in line:
            new_function = 'NO SUCH MODULE'
        return new_function

def get_renamed_classes(namespaces, classes):
    invalid_classes = []
    renamed_classes = {}
    new_classes = []
    code = ""
    for ns in namespaces:
        code += "import %s\n" % ns
    for cs in classes:
        code += "let _ = %s()\n" % cs
        mod = cs.replace("NS", "")
        if re.match(r"^NS.*", cs):
            if mod not in classes:
                classes.append(cs.replace("NS", ""))
                new_classes.append(cs.replace("NS", ""))

    fp = tempfile.NamedTemporaryFile(delete=False, suffix=".swift")
    fp.write(code)
    fp.close()
    cmd = "swiftc -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk -target x86_64-apple-ios9.0 %s" % fp.name
    process = Popen(shlex.split(cmd), stdout=PIPE, stderr=PIPE)
    (output, err) = process.communicate()
    exitcode = process.returncode
    for line in err.split("\n"):
        if "renamed" in line:
            m = re.match(r".*'(.*)' has been renamed to '(.*)'.*", line)
            if m is not None and m.groups() > 1:
                old_name = m.group(1)
                new_name = m.group(2)
                if old_name in classes:
                    classes.remove(old_name)
                classes.append(new_name)
                renamed_classes[old_name] = new_name
        elif "unresolved identifier" in line:
            m = re.match(r".* use of unresolved identifier '(.*)'.*", line)
            if m is not None and m.groups() > 1:
                invalid_name = m.group(1)
                if invalid_name in classes:
                    classes.remove(invalid_name)
                invalid_classes.append(invalid_name)
                if invalid_name in new_classes:
                    new_classes.remove(invalid_name)

    classes = list(set(classes))
    return (classes, invalid_classes, renamed_classes, new_classes)

def process_function_identifier(ruleid, namespacename, classname, functionname, expand_namespace, expand_classname, expand_functionname):
    print(ruleid)
    namespaces = []
    namespaces_new = []
    classes = []
    classes_new = []
    functions = []
    functions_new = []

    if expand_namespace:
        if namespacename is not None and exrex.count(namespacename) < 30:
            namespaces = exrex.generate(namespacename)
        else:
            print("    Infinite expansion")
    else:
        namespaces.append(namespacename)
    for namespace in namespaces:
        if namespace is not None and namespace != "None" and namespace != "":
            namespaces_new.append(namespace)

    if expand_classname:
        if classname is not None and exrex.count(classname) < 30:
            classes = exrex.generate(classname)
        else:
            print("    Infinite expansion")
    else:
        classes.append(classname)
    for clss in classes:
        if clss is not None and clss != "None" and clss != "":
            classes_new.append(clss)

    classes_new = list(set(classes_new))
    namespaces_new = list(set(namespaces_new))
    (classes_new, _, _, _) = get_renamed_classes(namespaces_new, classes_new)

    for (namespace, clss) in itertools.product(namespaces_new, classes_new):
        print("    Class: %s.%s" % (namespace, clss,))

    if expand_functionname:
        if functionname is not None and functionname != "+" and exrex.count(functionname) < 30:
            functions = exrex.generate(functionname)
        else:
            print("    Infinite expansion")
    else:
        functions.append(functionname)
    for function in functions:
        if function is not None and function != "None" and function != "":
            functions_new.append(function)

    for (namespace, clss, function) in itertools.product(namespaces_new, classes_new, functions_new):
        if namespace is not None and clss is not None and function is not None:
            functions = translate_swift_signature(function)
            for function in functions:
                new_function = get_renamed_function(namespace, clss, function)
                print("    Function: %s.%s.%s" % (namespace, clss, function))
                if function != new_function:
                    print("        %s" % new_function)
        elif namespace is not None and clss is not None:
            # Just a class name that should have already been processed as part of first query for classes
            pass
        else:
            print("    Not enough information to get new signature: %s.%s.%s" % (namespace, clss, function,))
    print("")

def process_structural_block(rule, ruleid, line):
    # Parse structural rule and generate AST
    lexer.lineno = 0
    ast = parser.parse(rule, lexer=lexer)
    api = get_structural_api_hierarchy()
    print("Regular AST: ")
    print_ast(ast)
    print("")

    # Expand references
    expanded = expand_references(ast, debug=False)
    print("Expanded AST: ")
    print_ast(expanded)
    print("")

    # Perform search and print nodes
    print("------- Class.name AST --------")
    search('Class.name', expanded, callback=print_ast )
    print("---------------")
    print("")

    # Perform search and print literals that reference is compared to
    print("------- Class.name COMP Literal --------")
    def print_literal(node):
        if node and node.type == "relation" and node.leaf in ["==", "matches"]:
            literal = node.children[1]
            print(literal.leaf)
    search('Class.name', expanded, callback=print_literal)
    print("---------------")
    print("")

    # Perform search and print nodes
    print("------- FunctionCall.function.name --------")
    search('FunctionCall.function.name', expanded, callback=print_ast)
    print("---------------")
    print("")

    # Perform search and print literals that reference is compared to
    print("------- FunctionCall.function.name COMP Literal --------")
    search('FunctionCall.function.name', expanded, callback=print_literal)
    print("---------------")
    print("")

    # Perform search and print regexp-expanded literals that reference is compared to
    # def print_expanded_literal(node):
    #     if node and node.type == "relation" and node.leaf in ["==", "matches"]:
    #         regex = node.children[1].leaf
    #         if exrex.count(regex) < 30:
    #             print('\n'.join(exrex.generate(regex)))
    # search('Class.name', expanded, callback=print_expanded_literal)
    # search('Function.name', expanded, callback=print_expanded_literal)
    # print("---------------")

    # Perform search and check if literals that reference is compared to matches a regexp
    # literal = "NSURLSession"
    # def matches_literal(node):
    #     #import ipdb; ipdb.set_trace()
    #     if node and node.type == "relation" and node.leaf in ["==", "matches"]:
    #         regex = node.children[1].leaf
    #         regex = regex.strip('"')
    #         if re.match(regex, literal):
    #             print("Matches")
    #             print_ast(node)
    # search('Class.name', expanded, callback=matches_literal)
    # print("---------------")

    # Perform search and print regexp-expanded literals that reference is compared to
    def get_rule_types(node):
        namespace = None
        types = None
        results = []
        if node and node.type == "relation":
            value = node.children[1].leaf.strip('"')
            m = re.match(r"\(([A-Za-z]+)\\\.\)\?(.*)", value)
            if m and len(m.groups()) == 2:
                namespace = m.groups()[0]
                clss = m.groups()[1]
            else:
                m = re.match(r"([A-Za-z]+)\.(.*)", value)
                if m and len(m.groups()) == 2:
                    namespace = m.groups()[0]
                    clss = m.groups()[1]
                else:
                    clss = value

            if node.leaf in ["is", "=="]:
                types = [clss]
            elif node.leaf in ["matches"]:
                if exrex.count(clss) < 30:
                    types = exrex.generate(clss)
                else:
                    print("    Infinite expansion")
            if types:
                for t in types:
                    #print("Module: %s Class: %s" % (namespace, t,))
                    results.append({"namespace": namespace, "class": t})
                return results
    # results = []
    # search('Class.name', expanded, callback=get_rule_types, results=results)
    # print(results)
    # print("---------------")
    def get_rule_functions(node):
        functions = []
        if node and node.type == "relation" and node.leaf in ["is", "==", "matches"]:
            regex = node.children[1].leaf.strip('"')
            if exrex.count(regex) < 30:
                functions += exrex.generate(regex)
            else:
                print("    Infinite expansion")
            classes = []
            search('Class.name', node.parent, callback=get_rule_types, results=classes)
            types = []
            search('Type.name', node.parent, callback=get_rule_types, results=types)
            results = []
            for f in functions:
                if len(classes + types) == 0:
                    o = {"function": f, "namespace": None, "class": None}
                    if not o in results:
                        results.append(o)
                for c in (classes + types):
                    o = {"function": f, "namespace": c['namespace'], "class": c['class']}
                    if not o in results:
                        results.append(o)
            return results

    print(ruleid)
    # print("[+] Print original rule")
    # print(rule)
    tmp_types = []
    search('Class.name', expanded, callback=get_rule_types, results=tmp_types)
    search('Type.name', expanded, callback=get_rule_types, results=tmp_types)
    classes = []
    for c in tmp_types:
        if not c in classes:
            classes.append(c)
    final_namespaces = []
    final_classes = []
    for c in classes:
        namespace = c.get("namespace", None)
        clss = c.get("class", None)
        if clss is not None:
            final_classes.append(clss)
        if namespace is not None:
            final_namespaces.append(namespace)
        if clss is not None and namespace is not None:
            #print("import %s; %s.init()" % (namespace, clss,))
            print("    Class: %s.%s" % (namespace, clss,))
        else:
            #print("Not enough information to get new signature: %s.%s" % (namespace, clss,))
            print("    Not enough information to get new signature: %s.%s" % (namespace, clss,))
    final_classes = list(set(final_classes))
    final_namespaces = list(set(final_namespaces))
    (final_classes, invalid_classes, renamed_classes, new_classes) = get_renamed_classes(final_namespaces, final_classes)

    results = []
    search('Function.name', expanded, callback=get_rule_functions, results=results)
    for r in results:
        namespace = r.get("namespace", None)
        clss = r.get("class", None)
        function = r.get("function", None)
        if namespace is not None and clss is not None and function is not None:
            functions = translate_swift_signature(function)
            for function in functions:
                new_clss = clss
                if renamed_classes.get(clss, None) is not None:
                    new_clss = renamed_classes[clss]
                new_function = get_renamed_function(namespace, new_clss, function)
                print("    Function: %s.%s.%s" % (namespace, clss, function))
                if clss != new_clss or function != new_function:
                    print("        %s" % new_function)
        elif namespace is not None and clss is not None:
            # Just a class name that should have already been processed as part of first query for classes
            pass
        else:
            print("    Not enough information to get new signature: %s.%s.%s" % (namespace, clss, function,))

    def print_expanded_literal(node):
        if node and node.type == "relation" and node.leaf in ["==", "matches"]:
            regex = node.children[1].leaf
            if exrex.count(regex) < 30:
                print('\n'.join(exrex.generate(regex)))
    search('Variable.name', expanded, callback=print_expanded_literal)
    search('Field.name', expanded, callback=print_expanded_literal)
    print("")

if __name__ == "__main__":
    f = None
    if len(argv) < 2:
        print("Usage: swiftmigrator.py <rulepack>")
        exit(-1)
    else:
        f = open(argv[1])
    rules = f.read()
    f.close()
    process_rules(rules.decode('utf-8'))
