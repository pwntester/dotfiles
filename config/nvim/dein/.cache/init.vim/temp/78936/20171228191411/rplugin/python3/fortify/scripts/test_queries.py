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

def process_structural_block(rule, ruleid, line):
    # Parse structural rule and generate AST
    lexer.lineno = 0
    ast = parser.parse(rule, lexer=lexer)
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
    results = []
    print("------- Class names regexp expanded --------")
    search('Class.name', expanded, callback=get_rule_types, results=results)
    print(results)
    print("---------------")
    print("")

    # Get Rule functions
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
    results = []
    print("------- Class Function names --------")
    search('Function.name', expanded, callback=get_rule_functions, results=results)
    for r in results:
        namespace = r.get("namespace", None)
        clss = r.get("class", None)
        function = r.get("function", None)
        if namespace is not None and clss is not None and function is not None:
            new_clss = clss
            print("    Function: %s.%s.%s" % (namespace, clss, function))
        elif namespace is not None and clss is not None:
            # Just a class name that should have already been processed as part of first query for classes
            pass
        else:
            print("    Not enough information to get new signature: %s.%s.%s" % (namespace, clss, function,))
    print("---------------")
    print("")


    # Print Variables and Fields
    def print_expanded_literal(node):
        if node and node.type == "relation" and node.leaf in ["==", "matches"]:
            regex = node.children[1].leaf
            if exrex.count(regex) < 30:
                print('\n'.join(exrex.generate(regex)))
    print("------- Variable and Field names --------")
    search('Variable.name', expanded, callback=print_expanded_literal)
    search('Field.name', expanded, callback=print_expanded_literal)
    print("---------------")
    print("")

if __name__ == "__main__":
    f = None
    if len(argv) < 2:
        print("Usage: " + argv[0] + " <rulepack>")
        exit(-1)
    else:
        f = open(argv[1])
    rules = f.read()
    f.close()
    process_rules(rules.decode('utf-8'))
