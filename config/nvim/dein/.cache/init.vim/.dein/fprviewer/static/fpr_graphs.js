
// Global vars
var to_node_map = {};
var from_node_map = {};
var visitors = {};
var nodes = [];
var links = [];

// Distance between nodes
var x_offset = 80;
var y_offset = 50;

function populate_link_maps(links) {
    // Populate to_node_map and from_node_map from links map
    links.forEach(function(link) {
        add_to_map(to_node_map, link.source, link.target);
        add_to_map(from_node_map, link.target, link.source);
    });
}

function add_to_map(map, key, value) {
    // Helper function to add elements to a map of arrays
    var array = map[key];
    if (array === undefined) array = [];
    array[array.length] = value;
    map[key] = array;
}

function last_visitor(id) {
    // Check if a given node has been visited as many times as nodes pointing to it
    add_to_map(visitors, id, 1);
    if (visitors[id].length == from_node_map[id].length) return true;
    else return false;
}

function horizontal_position_node(node, x, y) {
    // Main function to position nodes
    // Starts with the source node and traverse the graph positioning the nodes
    var id = node.graph_id;
    console.log("Processing " + node.id);

    // Node with multiple parents requires special handling
    if (from_node_map[id] !== undefined && from_node_map[id].length > 1) {
        console.log("Have more than one parent " + from_node_map[id] + " " + visitors[id]);
        if (!last_visitor(id)) {
            // Skipping positioning since there are still other parents nodes that will visit this node
            console.log("Someone else will position me " + x + ", " + y);
            return;
        }
        else {
            // No more visitors will get to this node so positioning
            console.log("I will position myself " + x + ", " + y);
        }
    }

    if (from_node_map[id] !== undefined) {
        // For nodes with one or more parents, check parent position and use it to calculate x 
        var new_x = 0;
        from_node_map[id].forEach(function(node_id) {
            new_x = nodes[node_id].x > new_x ? nodes[node_id].x : new_x;
        });
        node.x = new_x + x_offset;
        // TODO: instead of using y, check all parents positions and use one of them?
        node.y = y;
        //node.y = nodes[from_node_map[id][0]].y;
    } else {
        // Source node
        node.x = 100;
        node.y = y;
    }

    console.log(node.x, node.y);

    // Process children nodes
    var targets = to_node_map[node.graph_id];
    if (targets === undefined) return;
    targets.forEach(function(target, idx) {
        console.log("node " + node.id + " -> " + nodes[target].id);
        horizontal_position_node(nodes[target], x + x_offset, y + (y_offset*idx));
    });
}

function draw_dataflow_graph(nodes, links) {

    // Canvas size
    var width = 1500;
    var height = 500;

    var svg = d3.select("#graph")
        .append("svg")
        .attr("width", width)
        .attr("height", height);

    // Populate link helper maps
    populate_link_maps(links);

    // Find source node
    var source_node = nodes.filter(function(node) {
        if (node.is_source == "true") return true;
        else return false;
    })[0];

    // Position nodes starting from source
    horizontal_position_node(source_node, 100, 100);

    // D3 rendering

    // Markers
    var defs = svg.append('svg:defs');
    var markers = defs.selectAll("marker")
        .data(["end"])
        .enter()
        .append("svg:marker")
            .attr("id", String)
            .attr("viewBox", "0 -5 10 10")
            .attr("refX", 5)
            .attr("markerWidth", 6)
            .attr("markerHeight", 6)
            .attr("orient", "auto")
            .append("svg:path")
                .attr("d", "M0,-5L10,0L0,5");

    // Paths
    var paths = svg.append('svg:g')
        .attr('id', 'markers');

    var link = paths.selectAll("paths")
        .data(links)
        .enter()
        .append("svg:path")
            .attr("class", function(d) { return "link"; })
            .attr("marker-mid", function(d) { return "url(#end)"; })
            .attr('d', function(d) { 
                // Calculate path
                var source = nodes[d.source];
                var target = nodes[d.target];

                var distance_x = target.x - source.x;
                if (distance_x > x_offset) {
                    // If distance between nodes is bigger than x_offset, we will draw the path if different stretchs

                    var first_target = to_node_map[source.graph_id][0];
                    // If its the first link, go right, then down
                    var mx, my;
                    if (nodes[first_target].id == target.id) {
                        mx = target.x - x_offset;
                        my = source.y;
                    }
                    // Otherwise, go down, then right
                    else {
                        mx = source.x + x_offset;
                        my = target.y;
                    }
                    return [
                        "M",source.x,source.y,
                        "L",mx,my,
                        "L",target.x,target.y,
                    ].join(" ");
                } else {
                    // Its a one step jump, so no need for multiple stretchs
                    var middle_x = source.x + (target.x - source.x)/2;
                    var middle_y = source.y;

                    if (source.y == target.y) return [
                            "M", source.x, source.y,
                            "L", middle_x, middle_y,
                            "L", target.x, target.y,
                        ].join(" ");
                    else return [
                            "M", source.x, source.y,
                            "L", target.x, target.y,
                        ].join(" ");
                }
            });

    // Draw nodes
    var node = svg.selectAll(".nodes")
        .data(nodes)
        .enter()
        .append("g")
        .attr("class", "node");

    node.append("svg:circle")
        .attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; })
        .style("fill", function(d) {
            if (d.is_source == "true") return "green";
            else if (d.is_sink == "true") return "red";
            else return "#888";
        })
        .attr("r", function(d) {
            if (d.is_source == "true" || d.is_sink == "true") return 15;
            else return 10;
        })
        .on('click', function(d,i){ 
            // Show code snippet
            $.get("/snippet?path=" + d.path + "&line=" + d.line, function( snippet ) {
                $(".main-code").html(snippet);
                $("#line-" + d.line).addClass("hl-line");
            });
        });

    // Draw labels
    var label_direction = 1;
    var labels = svg.selectAll("text")
        .data(nodes)
        .enter()
        .append("text")
        .text(function(d) { return d.label; })
        .attr("text-anchor", "middle")
        .attr("y", function(d) { 
            // TODO: the 100 comes from the source node x position. need to automate this
            var label_pos = ((d.x-100)/x_offset) % 2 ? -1 : 1;
            return d.y + 30*label_pos; 
        })
        .attr("x", function(d) { return d.x; })
        .attr("font-size", ".75em")
        .attr("font-family", "sans-serif");

    // Tooltip
    var div = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);

    node.on("mouseover", function(d) {
            div.transition()
                .duration(200)
                .style("opacity", 0.9);
            div .html("Details: " + "<br/>"  + d.label)
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY - 28) + "px");
        })
        .on("mouseout", function(d) {
            div.transition()
                .duration(500)
                .style("opacity", 0);
        });
}

function draw_structural_graph(issue, nodes) {
    // Canvas size
    var width = 1500;
    var height = 500;

    var svg = d3.select("#graph")
        .append("svg")
        .attr("width", width)
        .attr("height", height);


    // Postion nodes
    var x = 100;
    var y = 100;

    nodes.unshift(issue);

    nodes.forEach(function(node) {
        node.x = x;
        node.y = y;
        x += 50;
    });

    // D3 rendering

    // Draw nodes
    var node = svg.selectAll(".nodes")
        .data(nodes)
        .enter()
        .append("g")
        .attr("class", "node");

    node.append("svg:circle")
        .attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; })
        .style("fill", function(d) {
            if (d.category === undefined) return "#888";
            else return "green";
        })
        .attr("r", function(d) {
            if (d.category === undefined) return 10;
            else return 15;
        })
        .on('click', function(d,i){
            // Show code snippet
            $.get("/snippet?path=" + d.path + "&line=" + d.line, function( snippet ) {
                $(".main-code").html(snippet);
                $("#line-" + d.line).addClass("hl-line");
            });
        });

    // Draw labels
    var label_direction = 1;
    var labels = svg.selectAll("text")
        .data(nodes)
        .enter()
        .append("text")
        .text(function(d) { return d.label; })
        .attr("text-anchor", "middle")
        .attr("y", function(d) { 
            // TODO: the 100 comes from the source node x position. need to automate this
            var label_pos = ((d.x-100)/x_offset) % 2 ? -1 : 1;
            return d.y + 30*label_pos; 
        })
        .attr("x", function(d) { return d.x; })
        .attr("font-size", ".75em")
        .attr("font-family", "sans-serif");

    // Tooltip
    var div = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);

    node.on("mouseover", function(d) {
            div.transition()
                .duration(200)
                .style("opacity", 0.9);
            div .html("Details: " + "<br/>"  + d.label)
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY - 28) + "px");
        })
        .on("mouseout", function(d) {
            div.transition()
                .duration(500)
                .style("opacity", 0);
        });
}

function draw_graph_for_issue(issue_id) {

    d3.json("/issue/" + issue_id, function(error, graph) {
        if (error) return console.warn(error);

        // Clear graph
        to_node_map = {};
        from_node_map = {};
        visitors = {};
        $('#graph').html("");

        if (graph.analyzer == "dataflow") {
            nodes = graph.nodes;
            links = graph.links;

            /*
            // TODO: Analysis Evidence Traces
            console.log(1)
            var traces = graph.traces;
            traces.forEach(function(trace) {
                trace.forEach(function(node) {
                    console.log(node.label);
                })
            });
            console.log(2)
            */

            /*
            // Just adding new nodes to make the graph more complex
            nodes[nodes.length] = {"is_source": "false", "is_sink": "false", "id": 999, "label": "TEST01"};
            nodes[nodes.length] = {"is_source": "false", "is_sink": "false", "id": 666, "label": "TEST02"};
            links[links.length] = {"source": 570, "target": 999}
            links[links.length] = {"source": 999, "target": 666}
            links[links.length] = {"source": 666, "target": 563}

            nodes[nodes.length] = {"is_source": "false", "is_sink": "false", "id": 1999, "label": "TEST11"};
            nodes[nodes.length] = {"is_source": "false", "is_sink": "false", "id": 1666, "label": "TEST12"};
            links[links.length] = {"source": 570, "target": 1999}
            links[links.length] = {"source": 1999, "target": 1666}
            links[links.length] = {"source": 1666, "target": 563}

            links[links.length] = {"source": 570, "target": 666}
            */

            // D3 uses graph.nodes indeces as indeces for links
            // Process links to use graph_nodes indices intead of SCA ones
            links.forEach(function(link) {
                source_idx = null;
                nodes.forEach(function (node, index) {
                    if (node.id === link.source) link.source = index;
                    if (node.id === link.target) link.target = index;
                    node.graph_id = index;
                });
            });
            draw_dataflow_graph(nodes, links);
        } else if (graph.analyzer == "structural") {
            draw_structural_graph(graph.issue, graph.nodes);
        } else {
            console.log("Analyzer: " + graph.analyzer + " not supported yet");
        }
    });
}
