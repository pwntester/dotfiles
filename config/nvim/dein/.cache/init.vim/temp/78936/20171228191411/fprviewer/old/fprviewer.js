// Written by Alvaro Muñoz Sanchez
// Copyright (c) 2013 Alvaro Muñoz Sanchez
//
// License: MIT

var fprviewer = null;

$(document).ready( function() {

	// Layout
	var ws = 300;
	var b = $('body').width();
	$('body').layout({
			minSize:					50,
		    north__size: 				50,
			west__size:					ws,
			stateManagement__enabled:	true,
			center__childOptions:	{
				minSize:				200,
				east__size:  			(b-ws)/2,
				center__onresize: function () {resize_svg();}
			}
	});
	resize_svg();

	fprviewer = new FPRViewer("http://localhost:7474/db/data/cypher", "http://localhost:9955");
	fprviewer.render_issue_menu();

	$('label.tree-toggler').click(function () {
		$(this).parent().children('ul.tree').toggle(300);
	});
	$('ul.tree').toggle();

	fprviewer.render_file_map();

});

var FPRViewer = function (neourl, fsurl) {
	this.db_url = neourl;
	this.file_server_url = fsurl;
	var base = "";
	$.ajax({
		type: "POST",
		url: this.db_url,
		data: { "query":"MATCH (n:Scan) RETURN n.base" },
		success: function(response) {base = response.data[0][0];},
		async: false
	});
    console.log(base);
	this.base = base;
};
FPRViewer.prototype.render_issue_menu = function() {
	var data = "<ul class='nav nav-list'>";
	var categories = fprviewer.get_categories();
	for (var i in categories) {
		var query = encodeURIComponent('full_category:"' + escapeHTML(categories[i][0]) + '"');
		data += "<li><label class='tree-toggler nav-header' style='overflow:auto;'>" +
			"<span>" + escapeHTML(categories[i][0]) + "</span>" +
			"<span class='label pull-right'>" +
			"<a href='#' onclick='fprviewer.render_graph(\"" + query + "\")' >[G]</a> [" +
			escapeHTML(categories[i][1]) +
			"]</span>" +
			"</label>" +
			"<ul class='nav nav-list tree'>";
		var issues = fprviewer.get_issues(categories[i][0]);
		for (var j in issues) {
			var query = encodeURIComponent('instance_id:"' + escapeHTML(issues[j].instance_id) + '"');
			var color = "";
			if (issues[j].severity >= 0)  color = "low";
			if (issues[j].severity >= 2)  color = "medium";
			if (issues[j].severity >= 4)  color = "high";
			if (issues[j].severity >= 5)  color = "critical";

			var file = "";
			var line = 0;
			if (issues[j].sink_location_file !== "") file = issues[j].sink_location_file;
			else file = issues[j].primary_location_file;
			if (issues[j].sink_location_line !== "0") line = issues[j].sink_location_line;
			else line = issues[j].primary_location_line;

			data += "<li><a href='#' onclick='fprviewer.render_issue_details(\"" +
				escapeHTML(issues[j].instance_id) +
				"\");fprviewer.render_graph(\"" + query + "\")' >" +
				// "<span class='label label-" + color + " pull-left'>" + issues[j].severity + </span>" +
				get_filename(file) +
				":" +
				escapeHTML(line) +
				"</a></li>";
		}
		data += "</ul></li>";
	}
	data += "</ul>";
	$("#content").html(data);
};
FPRViewer.prototype.get_categories = function() {
	var data = {
		"query":"MATCH (n:Category)<-[:BELONGS_TO]-(i:Issue) RETURN DISTINCT n.name, count(i) ORDER BY n.name"
	};
	var output = [];
	$.ajax({
		type: "POST",
		url: this.db_url,
		data: data,
		success: function(response) {
			for (var i in response.data) {
				output[output.length] = response.data[i];
			}
		},
		async: false
	});
	return output;
};
FPRViewer.prototype.get_issue_details = function(instance_id) {
	var data = {
		"query":"MATCH (n:Issue {instance_id: \"" + instance_id + "\"}) RETURN DISTINCT n"
	};
	var output = null;
	$.ajax({
		type: "POST",
		url: this.db_url,
		data: data,
		success: function(response) {
			output= response.data[0][0].data;
		},
		async: false
	});
	return output;
};
FPRViewer.prototype.get_node_details = function(node_id) {
	var data = {
		"query":"MATCH (n:TraceNode) WHERE ID(n) = " + node_id + " RETURN n"
	};
	var output = null;
	$.ajax({
		type: "POST",
		url: this.db_url,
		data: data,
		success: function(response) {
			output= response.data[0][0].data;
		},
		async: false
	});
	return output;
};
FPRViewer.prototype.get_issues = function(category) {
	var data = {
		"query":"MATCH (issue:Issue {full_category: '" + category+ "'}) RETURN DISTINCT issue ORDER BY issue.path"
	};
	var output = [];
	$.ajax({
		type: "POST",
		url: this.db_url,
		data: data,
		success: function(response) {
			for (var i in response.data) {
				output[output.length] = response.data[i][0].data;
			}
		},
		async: false
	});
	return output;
};
FPRViewer.prototype.render_node_details = function(node_id) {
	var node = this.get_node_details(node_id);
	// Get source code for trace node
	this.render_code(node.path, node.line);

	$("#details").html("<div>" + render_detail_lines(node) + "</div>");
};
FPRViewer.prototype.render_issue_details = function(instance_id) {
	var issue = this.get_issue_details(instance_id);
	var file = issue.sink_location_file !== "" ? issue.sink_location_file : issue.primary_location_file;
	var line = issue.sink_location_line !== "0" ? issue.sink_location_line : issue.primary_location_line;
	// Get source code for trace node
	this.render_code(file, line);

	$("#details").html("<div>" + render_detail_lines(issue) + "</div>");
};
FPRViewer.prototype.render_graph = function(query) {

	query = decodeURIComponent(query);

	// Create a new directed graph
	var g = new dagreD3.graphlib.Graph().setGraph({});

	var nodes = this.get_nodes(query);
	for (var j in nodes) {
		var css_class = "";
		if (nodes[j].is_source) css_class = "source";
		if (nodes[j].is_sink) css_class = "sink";

		var shortlocation = get_filename(nodes[j].path) + ":" + nodes[j].line;
		var location = nodes[j].path + ":" + nodes[j].line;

		var label = "";
		if (nodes[j].action_type !== "" && nodes[j].action !== "") label = "[" + nodes[j].action_type + "] " + nodes[j].action;
		else if (nodes[j].label !== "") label = nodes[j].label + "<br/>" + nodes[j].facts;
		else if (nodes[j].path !== "") label = nodes[j].path;

		if (nodes[j].is_sink) label += "<br/><b>" + nodes[j].taint_flags + "</b>";
		g.setNode(nodes[j].id, {
			id: nodes[j].id,
			label: label,
			width: 300,
			height: 50,
			labelType: "html",
			description: nodes[j].name,
			location: shortlocation,
			class: css_class
		});
	}

	var edges = this.get_edges(query);
	for (var j in edges) {
		g.setEdge(edges[j][0], edges[j][2], {label: ""});
	}

	// Set some general styles
	g.nodes().forEach(function(v) {
	  var node = g.node(v);
	  node.rx = node.ry = 5;
	});

	var svg = d3.select("svg"), inner = svg.select("g");

	// Set up zoom support
	var zoom = d3.behavior.zoom().on("zoom", function() {
      inner.attr("transform", "translate(" + d3.event.translate + ")" + "scale(" + d3.event.scale + ")");
    });
	svg.call(zoom);

	// Simple function to style the tooltip for the given node.
	var styleTooltip = function(name, description) {
	  return "<p class='name'>" + name + "</p><p class='description'>" + description + "</p>";
	};

	// Create the renderer
	var render = new dagreD3.render();

	// Run the renderer. This is what draws the final graph.
	render(inner, g);

	// Show popoup on hover
	// inner.selectAll("g.node")
	//   .attr("title", function(v) { return styleTooltip(v, g.node(v).location) })
	//   .each(function(v) { $(this).tipsy({ gravity: "w", opacity: 1, html: true, css: {width: 600} }); });

	// Click on node
	inner.selectAll("g.node").each(function(v) { $(this).click(function() {fprviewer.render_node_details($(this)[0].id);} )});

	// Center the graph
	var initialScale = 1;
	zoom
	  .translate([(svg.attr("width") - g.graph().width * initialScale) / 2, 20])
	  .scale(initialScale)
	  .event(svg);
};
FPRViewer.prototype.get_nodes = function(query) {
	var data = { "query":"MATCH (issue:Issue {" + query + "})-[:CONTAINS]->(t:Trace)-[:CONTAINS]->(n:TraceNode) RETURN distinct n, ID(n)" };
	var output = [];
	$.ajax({
		type: "POST",
		url: this.db_url,
		data: data,
		success: function(response) {
			for (var i in response.data) {
				var node = response.data[i][0].data;
				node.id = response.data[i][1];
				output[output.length] = node;
			}
		},
		async: false
	});
	return output;
};
FPRViewer.prototype.get_edges = function(query) {
	var data = {
		"query": "MATCH (issue:Issue {" + query + "})-[:CONTAINS]->(t:Trace)-[:CONTAINS]->(n:TraceNode) \
				 WITH n \
				 MATCH (n)-[r:NEXT]->(m:TraceNode)<-[:CONTAINS]-(t:Trace)<-[:CONTAINS]-(issue:Issue {" + query + "}) \
				 RETURN distinct ID(n),type(r), ID(m)",
	    "params": {}
	};
	var output = [];
	$.ajax({
		type: "POST",
		url: this.db_url,
		data: data,
		success: function(response) {
			for (var i in response.data) {
				output[output.length] = response.data[i];
			}
		},
		async: false
	});
	return output;
};
FPRViewer.prototype.render_code = function(file, line) {
	$.ajax({
	    type: "GET",
	    url: this.file_server_url + "/" + this.base + "/" + file,
	    crossDomain : true,
	    dataType: "text",
	    success: function(response) {
			var lines = response.split("\n");
			var digits = String(lines.length).length;
	    	var code = "<pre class='prettyprint linenums'>";
	    	for (var i in lines) {
	    		var j = parseInt(i) + 1;
	    		code += "<div id='line_" + j + "'>" +
	    		"<span class='linenum'>" + pad(j,digits) + " </span>" +
	    		"<span>" + escapeHTML(lines[i]) + "</span>" +
	    		"</div>";
	    	}
	    	code += "</pre>";
			$('#code').html(code);
			$('#codepanel').scrollTop(0);
			prettyPrint();
			$("#line_" + line).css("background-color", "yellow");
			var line_offset = $("#line_" + line).offset().top - $('#codepanel').offset().top;
			var delta = $('#codepanel').height()/2;
			$('#codepanel').scrollTop(line_offset - delta);
		}
	});
};
FPRViewer.prototype.render_file_map = function() {
	// var query_sinks = 'MATCH (s:SourceFile)<-[:IN]-(sink:TraceNode {is_sink: "true"}) RETURN  s.path,count(sink)';
	// var query_sources = 'MATCH (s:SourceFile)<-[:IN]-(source:TraceNode {is_source: "true"}) RETURN  s.path,count(source)';
	// var query_nodes = 'MATCH (s:SourceFile)<-[:IN]-(node:TraceNode) RETURN  s.path,count(node)';
};
FPRViewer.prototype.execute_query_sync = function(query) {
	var data = {'query': query};
	var output = null;
	$.ajax({
		type: "POST",
		url: this.db_url,
		data: data,
		success: function(response) {output = response.data;},
		async: false
	});
	return output;
};

function render_detail_lines(item) {
	var data = "";
	var keys = Object.keys(item);
	for (var i in keys) {
		if (keys[i] === "facts") {
			var facts = item[keys[i]].split(":::");
			for (var j in facts) {
				data += render_detail_line("fact_" + j, facts[j]);
			}
		} else if (keys[i] === "replacements") {
			var replacements = item[keys[i]].split(":::");
			for (var r in replacements) {
				if (replacements[r] !== "") {
					var kv = replacements[r].split("~~~");
					data += render_detail_line("Detail", kv[0] + " = " + kv[1]);
				}
			}
		} else if (keys[i] !== "primary_key") {
			data += render_detail_line(keys[i], item[keys[i]]);
		}
	}
	return data;
}

function render_detail_line(key, value) {
	if (value !== "" && value !== undefined && value !== null && value !== "0") {
		return "<p class='details'><span><strong>" + key + ": </strong></span><span>" + value + "</span></p>";
	} else return "";
}

function escapeHTML(text) {
	var data = String(text);
 	data = data.replace(/&/g, '&amp;');
 	data = data.replace(/</g, '&lt;');
 	data = data.replace(/>/g, '&gt;');
 	data = data.replace(/:/g, '&#58;');
 	return data;
}

function get_filename(path) {
	return escapeHTML(path).substr(path.lastIndexOf("/") + 1);
}

function pad(num, size) {
    var s = num+"";
    while (s.length < size) s = "0" + s;
    return s;
}

function resize_svg() {
	var w = $("#main").width();
	var h = $("#main").height();
    d3.select("#canvas").attr("width", w-3).attr("height", h-3);
}
