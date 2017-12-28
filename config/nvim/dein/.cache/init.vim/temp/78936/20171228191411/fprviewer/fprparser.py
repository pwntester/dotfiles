# Written by Alvaro Munoz Sanchez
# Copyright (c) 2013 Alvaro Munoz Sanchez
#
# License: MIT

_author_ = "Alvaro Munoz"

from zipfile import ZipFile
import tempfile
import os
import shutil
import sys
import requests
import logging
import zipfile
import lxml.etree as etree

__all__ = ["process_fpr"]

db = None
nested_nodes = {}

logging.disable(logging.INFO)

def add_to_path(path):
    """ Helper to work with several OSs """
    if os.name == 'nt':
        from ctypes import windll, create_unicode_buffer
        buf = create_unicode_buffer(512)
        if windll.kernel32.GetShortPathNameW(path, buf, len(buf)):
            path = buf.value
    if path not in sys.path:
        sys.path.append(path)

class Node(object):
    def __init__(self, label, properties):
        self.label = label
        self.properties = properties
        self.primary_key = properties.get('primary_key', None)

    def get_statements(self, idx):
        return [{"method":"POST",
            "to":"/node",
            "body": self.properties,
            "id": idx
            },
            {"method":"POST",
            "to":"{%s}/labels" % (idx,),
            "body": self.label}]

class Relationship(object):
    def __init__(self, source_idx, type, dest_idx, properties=None):
        self.source_index = source_idx
        self.dest_index = dest_idx
        self.type = type
        self.properties = properties
        if properties:
            self.primary_key = properties.get('primary_key', None)
        else:
            self.primary_key = None

    def get_statements(self, idx):
        return [{"method":"POST",
            "to":"{%d}/relationships" % (self.source_index,),
            "body": {
                "to" : "{%s}" % (self.dest_index,),
                "data": self.properties if self.properties else {},
                "type": self.type
            },
            "id": idx
        }]

class Batch(object):
    def __init__(self):
        self.items = []
        self.statements = []
        self.index = 0
        self.directory = {}

    def append(self, item):
        if item.primary_key is not None:
            self.directory["%s:::%s" % (str(item.label), str(item.primary_key),)] = self.index
        self.items.append(item)
        self.statements += item.get_statements(self.index)
        self.index += 1
        return self.index - 1

    def find(self, label, primary_key):
        return self.directory.get(label + ":::" + primary_key, None)

    def get_statements(self):
        return self.statements

    def get_items(self):
        return self.items

class Graph(object):
    def __init__(self, url):
        self.url = url
        self.cipher_url = "%s/cypher" % (url,)
        self.batch_url = "%s/batch" % (url,)

    def delete_all(self):
        payload = {'query': 'MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r'}
        #payload = urllib.parse.urlencode(payload)
        #payload = payload.encode('utf-8')
        # print(self.cipher_url)
        response = requests.post(self.cipher_url, data=payload )

    def run_batch(self, batch):
        payload = str(batch.get_statements()).replace("'",'"').encode('utf-8')
        # print(self.batch_url)
        headers = {"Accept": "application/json; charset=UTF-8","Content-Type": "application/json"}
        # request.add_header("X-Stream", "true")
        response = requests.post(self.batch_url, data=payload, headers=headers)
        #print(response.status_code)
        # print(response.text)

def process_node_ref(batch, ref_node, issue_idx, issue_trace_idx, prev_nodes_idx=None):
    ref_node_idx = batch.find('TraceNode', ref_node)
    return_nodes_idx = [ref_node_idx]
    # Add ref node to current issue and trace
    batch.append(Relationship(ref_node_idx, 'BELONGS_TO', issue_idx))
    batch.append(Relationship(issue_trace_idx, 'CONTAINS', ref_node_idx))
    # If there is a previous node, create a NEXT relationship
    if prev_nodes_idx is not None:
        for prev_idx in prev_nodes_idx:
            batch.append(Relationship(prev_idx, 'NEXT', ref_node_idx))
    # Process norefs recursively
    if nested_nodes.get(ref_node, None) is not None:
        # There are nested node refs
        nested_node_refs = nested_nodes[ref_node]
        if nested_node_refs is not None:
            prev_nested_nodes_idx = [ref_node_idx]
            for i, nested_node in enumerate(nested_node_refs):
                nested_node_idx = batch.find('TraceNode', nested_node)
                process_node_ref(batch, nested_node, issue_idx, issue_trace_idx, prev_nodes_idx=prev_nested_nodes_idx)
                prev_nested_nodes_idx = [nested_node_idx]
                if i == (len(nested_node_refs) - 1):
                    return_nodes_idx.append(nested_node_idx)
    return return_nodes_idx

def escapeProp(prop):
    prop = str(prop)
    prop = prop.replace('"', "&quote;")
    prop = prop.replace("'", "&quote;")
    return prop


def process_fpr(fpr_name):

    # Extracting FPR contents in tmp dir
    tmpdir = os.path.join(tempfile.gettempdir(), 'fortify_viewer')
    if os.path.exists(tmpdir):
        shutil.rmtree(tmpdir)
    os.makedirs(tmpdir)
    print("[+] Extracting %s to %s" % (fpr_name, tmpdir,))
    fpr_file = zipfile.ZipFile(fpr_name)
    fpr_file.extractall(tmpdir)
    print("[+] Processing %s" % (os.path.join(tempfile.gettempdir(), 'fortify_viwer', "audit.fvdl"),))
    tree = etree.parse(os.path.join(tmpdir, "audit.fvdl"))


    print('[+] Initializing DB')
    db = Graph('http://localhost:7474/db/data')
    db.delete_all()
    batch = Batch()

    print("[+] Processing Scan Details")
    baseElement = tree.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceBasePath')
    if baseElement is not None:
        scan = Node("Scan", {
            'base':baseElement.text
        })
        batch.append(scan)

    # Process Files
    print("[+] Processing Files")
    files = tree.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceFiles/{xmlns://www.fortifysoftware.com/schema/fvdl}File')
    for f in files:
        path = f.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Name').text
        source_file = Node("SourceFile", {
            'type':f.get('type'),
            'path':path,
            'primary_key':path
        })
        batch.append(source_file)

    print("[+] Entities so far: %d" % (len(batch.items),))

    # Process Common TraceNodes
    print("[+] Processing Common TraceNodes")
    nodes = tree.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}UnifiedNodePool/{xmlns://www.fortifysoftware.com/schema/fvdl}Node')
    for n in nodes:
        locationElement = n.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation')
        path = ""
        line = 0
        if locationElement is not None:
            path = locationElement.get('path')
            line = locationElement.get('line')

        actionElement = n.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Action')
        action_type = ""
        action = ""
        if actionElement is not None:
            action_type = actionElement.get('type', "")
            action = actionElement.text

        ruleElement = n.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Rule')
        ruleID = ""
        if ruleElement is not None:
            ruleID = ruleElement.get('ruleID')

        taintFlagsElement = n.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Fact[@type='TaintFlags']")
        taint_flags = ""
        if taintFlagsElement is not None:
            taint_flags = taintFlagsElement.text

        factElements = n.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Fact")
        facts = []
        if factElements is not None:
            for factElement in factElements:
                facts.append(factElement.text)

        label = n.get('label', "")
        node_id = n.get('id', -1)

        trace_node = Node("TraceNode", {
            'action':escapeProp(action),
            'action_type':escapeProp(action_type),
            'node_id':node_id,
            'path':escapeProp(path),
            'ruleID':ruleID,
            'line':line,
            'taint_flags': escapeProp(taint_flags),
            'facts': escapeProp(":::".join(facts)),
            'label': escapeProp(label),
            'primary_key': node_id,
            'is_source': "false",
            'is_sink': "false",
        })
        trace_node_idx = batch.append(trace_node)
        source_file_idx = batch.find("SourceFile", path)
        rel = Relationship(trace_node_idx, "IN", source_file_idx)
        batch.append(rel)

    print("[+] Entities so far: %d" % (len(batch.items),))

    # Process nested nodes
    print("[+] Processing Nested Nodes")
    global nested_nodes
    for n in nodes:
        source_node_id = n.get('id')
        if source_node_id is not None:
            # Look for nested nodes
            refsElements = n.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}NodeRef")
            if refsElements is not None:
                refs = []
                for ref in refsElements:
                    target_node_id = ref.get('id')
                    if target_node_id is not None:
                        source_node_idx = batch.find("TraceNode", source_node_id)
                        target_node_idx = batch.find("TraceNode", target_node_id)
                        if source_node_idx > 0 and target_node_idx > 0:
                            refs.append(target_node_id)
                nested_nodes[source_node_id] = refs

    # Process Issues
    print("[+] Processing Issues")
    vulns = tree.findall('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Vulnerability')
    for v in vulns:
        category_name = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Type').text
        instance_id = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}InstanceID').text
        severity = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}InstanceSeverity').text
        confidence = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Confidence').text
        analyzer = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}AnalyzerName').text
        rule_id = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}ClassID').text
        if rule_id is None:
            rule_id = ""

        replacement_elements = v.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}ReplacementDefinitions/{xmlns://www.fortifysoftware.com/schema/fvdl}Def")
        replacements = ""
        if replacement_elements is not None:
            for replacement in replacement_elements:
                replacements += replacement.get('key') + "~~~"
                replacements += replacement.get('value') + ":::"

        locations = v.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}ReplacementDefinitions/{xmlns://www.fortifysoftware.com/schema/fvdl}LocationDef")
        sink_location_file = ""
        sink_location_line = 0
        source_location_file = ""
        source_location_line = 0
        if locations is not None:
            for location in locations:
                if location.get('key') == "SinkLocation":
                    sink_location_file = location.get('path')
                    sink_location_line = location.get('line')
                if location.get('key') == "SourceLocation":
                    source_location_file = location.get('path')
                    source_location_line = location.get('line')

        primary_location_file = ""
        primary_location_line = 0

        function_source_location_element = v.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}FunctionDeclarationSourceLocation")
        if function_source_location_element is not None:
            primary_location_file = function_source_location_element.get('path')

        source_location_element = v.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation")
        if source_location_element is not None:
            primary_location_file = source_location_element.get('path')
            primary_location_line = source_location_element.get('line')

        def_location_line_element = v.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}ReplacementDefinitions/{xmlns://www.fortifysoftware.com/schema/fvdl}Def[@key='PrimaryLocation.line']")
        if def_location_line_element is not None:
            primary_location_line = def_location_line_element.get('value')

        if primary_location_file == "" or primary_location_line == 0:
            print("Skipping issue %s" % instance_id)
            continue

        subcategoryElement = v.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Subtype')
        subcategory_name = ""
        if subcategoryElement is not None:
            if subcategoryElement.text is not None:
                subcategory_name = subcategoryElement.text
        if (subcategory_name is not None and subcategory_name is not ""):
            full_category = category_name + ": " + subcategory_name
        else:
            full_category = category_name

        category_idx = batch.find("Category", full_category)
        if category_idx is None:
            category = Node("Category", {
                'name': escapeProp(full_category),
                'category': escapeProp(category_name),
                'subcategory': escapeProp(subcategory_name),
                'primary_key': escapeProp(full_category)
            })
            category_idx = batch.append(category)

        issue = Node("Issue", {
            'instance_id': escapeProp(instance_id),
            'rule_id': escapeProp(rule_id),
            'full_category': escapeProp(full_category),
            'analyzer': escapeProp(analyzer),
            'category': escapeProp(category_name),
            'subcategory': escapeProp(subcategory_name),
            'confidence': escapeProp(confidence),
            'severity': escapeProp(severity),
            'primary_location_file': escapeProp(primary_location_file),
            'primary_location_line': escapeProp(primary_location_line),
            'source_location_file': escapeProp(source_location_file),
            'source_location_line': escapeProp(source_location_line),
            'sink_location_file': escapeProp(sink_location_file),
            'sink_location_line': escapeProp(sink_location_line),
            'replacements': replacements,
            'source_node_id': "",
            'sink_node_ids': "",
            'primary_key': escapeProp(instance_id)
        })
        issue_idx = batch.append(issue)
        rel = Relationship(issue_idx, "BELONGS_TO", category_idx)
        batch.append(rel)

        if analyzer in ['dataflow', 'structural', 'semantic', 'controlflow', 'configuration']:
            traces = v.findall('./{xmlns://www.fortifysoftware.com/schema/fvdl}AnalysisInfo/{xmlns://www.fortifysoftware.com/schema/fvdl}Unified/{xmlns://www.fortifysoftware.com/schema/fvdl}Trace')
            trace_index = 0
            trace_node_idx = 0
            for trace in traces:
                trace_id = instance_id + "_" + str(trace_index)
                issue_trace = Node("Trace", {'index': trace_id})
                issue_trace_idx = batch.append(issue_trace)
                batch.append(Relationship(issue_idx, 'CONTAINS', issue_trace_idx))
                entries = trace.findall('./{xmlns://www.fortifysoftware.com/schema/fvdl}Primary/{xmlns://www.fortifysoftware.com/schema/fvdl}Entry')
                index = 0
                prev_nodes_idx = None
                for e in entries:
                    ref = e.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}NodeRef')
                    if ref is not None:
                        if prev_nodes_idx is not None:
                            prev_nodes_idx = process_node_ref(batch, ref.get('id'), issue_idx, issue_trace_idx, prev_nodes_idx=prev_nodes_idx)
                        else:
                            prev_nodes_idx = process_node_ref(batch, ref.get('id'), issue_idx, issue_trace_idx)
                        trace_node_idx = batch.find("TraceNode", ref.get('id'))
                    else:
                        n = e.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Node')
                        if n is not None:
                            locationElement = n.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}SourceLocation')
                            path = ""
                            line = "0"
                            if locationElement is not None:
                                path = str(locationElement.get('path'))
                                line = str(locationElement.get('line'))

                            actionElement = n.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Action')
                            action_type = ""
                            action = ""
                            if actionElement is not None:
                                action_type = str(actionElement.get('type', ""))
                                action = str(actionElement.text)

                            ruleElement = n.find('.//{xmlns://www.fortifysoftware.com/schema/fvdl}Rule')
                            ruleID = ""
                            if ruleElement is not None:
                                ruleID = str(ruleElement.get('ruleID'))

                            taintFlagsElement = n.find(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Fact[@type='TaintFlags']")
                            taint_flags = ""
                            if taintFlagsElement is not None:
                                taint_flags = str(taintFlagsElement.text)

                            factElements = n.findall(".//{xmlns://www.fortifysoftware.com/schema/fvdl}Fact")
                            facts = []
                            if factElements is not None:
                                for factElement in factElements:
                                    facts.append(factElement.text)

                            label = n.get('label', "")
                            node_id = n.get('id', -1)

                            pkey = escapeProp(path + "::" + line + "::" + action_type + "::" + action + "::" + ruleID + "::" + taint_flags + "::" + str(":::".join(facts)))

                            trace_node = Node("TraceNode", {
                                'action': escapeProp(action),
                                'action_type': escapeProp(action_type),
                                'node_id': escapeProp(node_id),
                                'path': escapeProp(path),
                                'line': escapeProp(line),
                                'ruleID': escapeProp(ruleID),
                                'label': escapeProp(label),
                                'taint_flags': taint_flags,
                                'facts': escapeProp(":::".join(facts)),
                                'primary_key': pkey,
                                'is_source': "false",
                                'is_sink': "false",
                            })
                            trace_node_idx = batch.find("TraceNode", pkey)
                            if trace_node_idx is None:
                                trace_node_idx = batch.append(trace_node)
                            source_file_idx = batch.find("SourceFile", path)
                            batch.append(Relationship(trace_node_idx, 'IN', source_file_idx))
                            batch.append(Relationship(trace_node_idx, 'BELONGS_TO', issue_idx))
                            batch.append(Relationship(issue_trace_idx, 'CONTAINS', trace_node_idx))

                            if prev_nodes_idx is not None:
                                for prev_idx in prev_nodes_idx:
                                    batch.append(Relationship(prev_idx, 'NEXT', trace_node_idx))
                            prev_nodes_idx = [trace_node_idx]

                    # update trace node with source/sink information
                    if trace_node_idx is not None and analyzer in ['dataflow']:
                        t = batch.items[trace_node_idx]
                        if index == len(entries) - 1:
                            t.properties['is_sink'] = "true"
                            t.properties['is_source'] = "false"
                        elif index == 0:
                            t.properties['is_source'] = "true"
                            t.properties['is_sink'] = "false"
                        else:
                            t.properties['is_sink'] = "false"
                            t.properties['is_source'] = "false"

                    index += 1
                trace_index += 1

    print("[+] Entities to import: %d" % (len(batch.items),))
    print("[+] Executing batch import")
    db.run_batch(batch)
    print("[+] Done processing FPR")



if __name__ == "__main__":
    if len(sys.argv) == 2:
        process_fpr(sys.argv[1])





