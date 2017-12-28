#!/usr/bin/env python
from json import dumps

from flask import Flask, Response, request, render_template, send_from_directory

from neo4jrestclient.client import GraphDatabase, Node

from pygments import highlight
from pygments.lexers import PythonLexer
from pygments.formatters import HtmlFormatter
from pygments.lexers import guess_lexer_for_filename

app = Flask(__name__, static_url_path='/static/')
app.debug = True
gdb = GraphDatabase("http://localhost:7474")


@app.route("/")
def get_index():
    return render_template('index.html')

@app.route('/static/<path:path>')
def send_static(path):
    return send_from_directory('static', path)

@app.route("/issue/<path:iid>")
def get_issue(iid):
    print("Getting nodes for %s" % iid)

    # get analyzer
    query = ('Match (issue:Issue {instance_id:{iid}}) return issue.analyzer')
    analyzer = gdb.query(query, params={"iid": iid})[0][0]

    # scan base
    query = ('MATCH (n:Scan) RETURN n.base')
    base = gdb.query(query)[0][0]

    if analyzer in ["dataflow", "structural"]:
        # issue
        query = ('MATCH (issue:Issue {primary_key:{iid}}) RETURN issue')
        results = gdb.query(query, params={"iid": iid})
        issue = results[0][0]['data']

        # nodes
        query = ('MATCH (issue:Issue {primary_key:{iid}})-[:CONTAINS]->(t:Trace)-[:CONTAINS]->(n:TraceNode) RETURN distinct ID(n) as id, n as node')
        results = gdb.query(query, params={"iid": iid})
        nodes = []
        for nid, node in results:
            nodes.append({
                "id": nid,
                "label": node['data']['action'],
                "is_source": node['data']['is_source'],
                "is_sink":node['data']['is_sink'],
                "type":node['data']['action_type'],
                "path":base + "/" + node['data']['path'],
                "line":node['data']['line']
            })

        # links
        query = ('MATCH (issue:Issue {primary_key:{iid}})-[:CONTAINS]->(t:Trace)-[:CONTAINS]->(n:TraceNode) WITH n MATCH (n)-[r:NEXT]->(m:TraceNode)<-[:CONTAINS]-(t:Trace)<-[:CONTAINS]-(issue:Issue {primary_key:{iid}}) RETURN distinct ID(n) as source_id,type(r) as type, ID(m) as target_id')
        results = gdb.query(query, params={"iid": iid})
        rels = []
        for source, rel, target in results:
            rels.append({"source": source, "target": target})

        # traces
        traces = []
        """
        query = ('Match (issue:Issue {instance_id:{iid}}) --> (trace:Trace) return trace.index')
        results = gdb.query(query, params={"iid": iid})
        for trace in results:
            # trace nodes
            query = ('MATCH (t:Trace {index:{trace}})-[:CONTAINS]->(n:TraceNode) RETURN n as node ORDER BY n.id')
            results = gdb.query(query, params={"trace":trace[0]})
            trace_nodes = []
            for node in results:
                trace_nodes.append({
                    "label": node[0]['data']['action'],
                    "is_source": node[0]['data']['is_source'],
                    "is_sink":node[0]['data']['is_sink'],
                    "type":node[0]['data']['action_type'],
                    "path":base + "/" + node[0]['data']['path'],
                    "line":node[0]['data']['line']
                })
            traces.append(trace_nodes)
        """

        return Response(dumps({"analyzer": analyzer, "nodes": nodes, "links": rels, "traces": traces, "issue":issue}), mimetype="application/json")

    else:
        return Response(dumps({"analyzer": analyzer, "nodes": [], "links": [], "traces": []}), mimetype="application/json")


@app.route("/categories")
def get_categories():
    query = ('MATCH (n:Category)<-[:BELONGS_TO]-(i:Issue) RETURN DISTINCT n.name, count(i) ORDER BY n.name')
    results = gdb.query(query)
    categories = []
    for category, count in results:
        issues_query = ('MATCH (issue:Issue {full_category:{category}}) RETURN DISTINCT issue ORDER BY issue.path')
        issues_results = gdb.query(issues_query, params={"category": category})
        issues = []
        for issue in issues_results:
            issues.append({"instance_id": issue[0]['data']['instance_id'], "file": issue[0]['data']['primary_location_file'], "line": issue[0]['data']['primary_location_line']})
        categories.append({"name": category, "count": count, "issues": issues})
    return Response(dumps(categories), mimetype="application/json")

@app.route("/snippet")
def get_snippet():
    path = request.args.get('path', '')
    line = int(request.args.get('line', 0))
    content = open(path, 'r').readlines()
    content.insert(0,"")
    min_line = max(line - 5,0)
    max_line = min(line + 5, len(content)-1)
    while True:
        if content[min_line].strip() == "":
            min_line += 1
        else:
            break
    print(min_line, max_line)
    code = "".join(content[min_line:max_line])
    formatter = HtmlFormatter(linenos=True, cssclass="highlight", linenostart=min_line, linespans="line")
    lexer = guess_lexer_for_filename(path, "".join(content))
    snippet = highlight(code, lexer, formatter)
    return Response(snippet, mimetype="plain/text")



if __name__ == '__main__':
    app.run(port=8080)
