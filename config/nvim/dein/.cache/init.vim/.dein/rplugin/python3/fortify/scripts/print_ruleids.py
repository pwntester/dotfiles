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

prev_ruleid = None
ruleid = None
count = 0

def process_rules(xml, query):
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
                process_structural_block(str(predicate.text), str(ruleid.text), baseline, query)

def print_ruleid(node, level=0):
    global prev_ruleid
    if ruleid != prev_ruleid:
        print(ruleid)
    prev_ruleid = ruleid

def process_structural_block(rule, rid, line, query):
    global ruleid
    global count
    count += 1

    lexer.lineno = 0
    ast = None
    try:
        ast = parser.parse(rule, lexer=lexer)
    except:
        # Ignore syntax errors, there are caused by rules with PUT_PLACEHOLDER_HERE and alikes
        # print("Syntax error parsing: " + rid + ". Probably a scripted rule")
        pass
    if ast is None:
        return
      
    process_ast(ast, printAST=False)
    expanded = expand_references(ast, debug=False)
    #print("")
    #print_ast(expanded)
    ruleid = rid
    search(query, expanded, callback=print_ruleid )

if __name__ == "__main__":
    f = None
    if len(argv) < 3:
        print("Usage: " + argv[0] + " <rulepack> <query>")
        exit(-1)
    else:
        f = open(argv[1])
    rules = f.read()
    f.close()
    process_rules(rules.decode('utf-8'), argv[2])
    print(count)
