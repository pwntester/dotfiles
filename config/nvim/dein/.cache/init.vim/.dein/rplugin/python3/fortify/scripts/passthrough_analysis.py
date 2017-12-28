#!/usr/local/bin/python
from __future__ import print_function

# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

import exrex
import re
import itertools
import sys
import tempfile
import shlex
from subprocess import Popen, PIPE


def process_taintflags():
    t = open('/Users/alvaro/P4/rules/sca/branches/head/config/taintFlags.csv')
    csv= t.readlines()
    tf = []
    for line in csv:
        fields = line.split(",")
        if fields[2] == "SPECIFIC" or fields[2] == "GENERAL":
            tf.append(fields[0])
    print("SPECIFIC/GENERAL TaintFlags: " + str(len(tf)))
    t.close()
    return tf


def process_rules(xml, flags):
    exceptions = ["XSS", "POORVALIDATION"]
    namespaces = {"f": "xmlns://www.fortifysoftware.com/schema/rules", "re": "http://exslt.org/regular-expressions"}
    context = ltree.iterparse(BytesIO(xml.encode('utf-8')), strip_cdata=False)
    for action, elem in context:
        if re.match(r'(?i).*CharacterizationRule$', elem.tag):
            ruleid = str(elem.find("./f:RuleID", namespaces=namespaces).text)
            definition = elem.find("./f:Definition", namespaces=namespaces)
            if definition is not None:
                d = definition.text
                props = d.split("\n")
                for prop in props:
                    if "TaintTransfer" in prop:
                        text = re.search('{(.+)}', prop)
                        if text is not None:
                            text = text.group(1)
                            text = text.replace("+","")
                            text = text.replace("-","")
                            tfs = text.split(" ")
                            for flag in tfs:
                                if flag in flags:
                                    if flag not in exceptions:
                                        print(ruleid + ": " + flag)

        elif re.match(r'(?i).*DataflowPassthroughRule$', elem.tag):
            ruleid = str(elem.find("./f:RuleID", namespaces=namespaces).text)
            tf= elem.find("./f:TaintFlags", namespaces=namespaces)
            if tf is not None:
                text = tf.text
                text = text.replace("+","")
                text = text.replace("-","")
                tfs = text.split(",")
                for flag in tfs:
                    if flag in flags:
                        if flag not in exceptions:
                            print(ruleid + ": " + flag)
                


if __name__ == "__main__":
    f = None
    if len(argv) < 2:
        print("Usage: pt_anal.py <rulepack>")
        exit(-1)
    else:
        f = open(argv[1])

    tf = process_taintflags()

    rules = f.read()
    f.close()
    process_rules(rules.decode('utf-8'), tf)
