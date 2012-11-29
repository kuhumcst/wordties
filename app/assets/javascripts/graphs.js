function rel_graph(data, labels) {
	var colors;
	
	function create(colors) {
		// SVG Panel
		var h = 600;
		var w = 750;
		var r = 170;
		
		var svg = d3.select('#relGraph').insert('svg', 'div.graphSelectBox').attr('top', 30).attr('width', w).attr('height', h);
		var container = svg.append("g").attr("class", "container").attr("transform", "translate(" + (w/2 - 75) + ", " + (h/2 + 30) + ")");
		
		// Tree layout
		var tree = d3.layout.cluster().size([360, r]).separation(function(a, b) { return ((a.parent == b.parent) && (a.rel_type == b.rel_type) ? 1 : 2) / a.depth; }); // leaf nodes at same (one) level
		var nodes = tree.nodes(data);
		var links = tree.links(nodes);
		// Legend
		var myKeys=d3.nest()
			.key(function(d) {return d.rel_type;})
			.entries(flare.children);
		
		// 360 rotation
		var diagonal = d3.svg.diagonal.radial().projection(function(d) { 
			return [d.y, d.x / 180 * Math.PI];
		});
		
		// Path/Line
		container.append("g").attr("class", "tree").selectAll(".link").data(links).enter()
			.append("path")
			.style("stroke", function(d) { return colors(d.target.rel_type); })
			.attr("class", "link")
			.attr("d", diagonal);
			
		// Nodes
		var nodeGroup = container.select(".tree").selectAll("g.node")
		 .data(nodes)
		 .enter()
		 .append("g")
		 .attr("class", "node")
		 .attr("transform", function(d) {
		       return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")";
		 });
		 
		 nodeGroup.append("symbol")
		 .attr("class", "node")
		 .size(0);
		
		 // Label
		 var label = nodeGroup.append("text")
		 .attr("class", "label")
		 .attr("dy", ".31em")
		 .text(function(d) { return d.name; })
		 .attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
		 .attr("transform", function(d) { return d.x < 180 ? "translate(8)" : "rotate(180)translate(-8)"; })
		 .attr("visibility", function(d) { return d.depth > 0  ? "visible" : "hidden" })
		 .on("mouseover", function() { d3.select(this).attr("class", "label hover")})
		 .on("mouseout", function() { d3.select(this).attr("class", "label") })
		 .on("click", function(d) { document.location = d.link; });     
		 
		 // Tooltip
		 label.append("title").text(function(d) { return d.gloss; });
		 
		 // Sense lemma  
		 container.append("text")
		  .attr("class", "root-node-label")
		  .attr("dy", ".31em")
		  .attr("text-anchor", "middle")
		  .classed("large", function(d) { return nodes[0].name.length <= 10; })
		  .text(nodes[0].name);
		  
		  var legend_container = svg.append("g").attr("class", "legend-container").attr("transform", "translate(600, 125)");
		  legend_container.append("text").text(labels[0]).attr("text-anchor", "start").attr("transform", "translate(0,0)");
		  var legend = legend_container.selectAll(".legend")
		  .data(myKeys)
		  .enter().append("g")
		  .attr("class", "legend")
		  .attr("transform", function(d, i) { return "translate(0," + ((i*20)+20) + ")"; });
		  
		  legend.append("rect")
		      .attr("width", 8)
		      .attr("height", 8)
		      .style("fill", function(d) { return colors(d.key); })
		      .attr("transform", "translate(5, 5)");
		  
		  legend.append("text")
		      .attr("y", 8)
		      .attr("dy", ".35em")
		      .style("text-anchor", "start")
		      .text(function(d) { return d.key; })
		      .attr("transform", "translate(15, 0)");	 
	}
	
	d3.json('../assets/rel-colors.json', function(json) {
		// List of Rel Types
		var rels = json.children.map(function(d) { return d.rel; });
		var color_range = json.children.map(function(d) { return d.color; });
		var color_cat_override = json.d3CategoryOverride;

		// Ordinal scale Cat20c
		var colors = (color_cat_override) ? d3.scale[color_cat_override]().domain(rels) : d3.scale.ordinal().domain(rels).range(color_range);
		
		// Create graph
		create(colors);
	});
}

function hypo_graph(data, hyponym_count) {
	
	var w = 670, 
		h = 670,
		padding = 30,
		r = w/2,
		x = d3.scale.linear().range([0, 2 * Math.PI]),
	    y = d3.scale.pow().exponent(1.2).domain([0, 1]).range([0, r]),
		radius = Math.min(w,h)/2,
		catColors = d3.scale.category20(),
		hyponymCount = hyponym_count;
		
	var svg = d3.select("#hypoGraph .center").append("svg").attr("width", w + padding).attr("height", h + padding).append("g").attr("transform", "translate(" + [r+padding/2, r+padding/2] + ")");
	
	var partition = d3.layout.partition()
	 	.value(function(d) { return d.hyponym_count; });
	
	var arc = d3.svg.arc()
				.startAngle(function(d) { return Math.max(0, Math.min(2 * Math.PI, x(d.x))); })
				.endAngle(function(d) { return Math.max(0, Math.min(2 * Math.PI, x(d.x + d.dx))); })
				.innerRadius(function(d) { return Math.max(0, d.y ? y(d.y) : d.y); })
				.outerRadius(function(d) { return Math.max(0, y(d.y + d.dy)); });
	
	var nodes = partition.nodes(data);
	
	svg.selectAll("path")
		.data(nodes)
		.enter()
		.append("path")
		.attr("id", function(d, i) { return "path-" + i; })
		.attr("d", arc)
		.attr("class", function(d) { return (d.name != "rest" && d.depth > 0) ? "arc" : "arc-nolink"; })
		.attr("display", function(d) { return (d.value >= 0) ? null : "none" })
		.attr("fill-rule", "evenodd")
		.style("stroke", "#fff")
		.style("fill", function(d) { return catColors(d.parent_id*d.depth);  })
		.attr("fill-opacity", function(d) { return (d.name == "rest") ? 0.4 : 1; }) // apply alpha for 'rest'
		.on("click", click)
		.append("title").text(function(d) {
	  		if(d.depth <= 0) return "100% (" + hyponymCount + ")"; 
	  		var ofTotal = parseFloat(d.hyponym_count) / hyponymCount
	  		return (ofTotal*100).toFixed(1) + " % (" + d.hyponym_count + " / " + hyponymCount + " )"
		});
	
	var text = svg.selectAll("text").data(nodes).enter().append("text")
	  	.attr("id", function(d, i) { return "label-" + i; })
	  	.style("fill-opacity", 1)
	  	.style("fill", "#000")
	  	.attr("class", function(d) { return (d.name != "rest" && d.depth > 0) ? "label": "label-nolink"; })
	  	.classed("large", function(d) { return d.depth == 0; })
	  	.attr("text-anchor", function(d) {
	    	return "middle";
	    	//return x(d.x + d.dx / 2) > Math.PI ? "end" : "start";
	  	})
	  	.attr("dy", ".2em")
	  	.attr("transform", function(d) {
	    	if(d.depth == 0) return "translate(0, 0)";
	  		var angle = x(d.x + d.dx / 2) * 180 / Math.PI - 90;
	    	return "rotate(" + angle + ")translate(" + (y(d.y) + padding) + ")rotate(" + (angle > 90 ? -180 : 0) + ")";
	  	})
	  	.text(function(d) { return (d.name != "rest") ? d.name : ""; })
		.attr("visibility", function(d) { return (((y(d.y)*x(d.dx) >= 6) && d.name != 'rest') || d.y == 0) ? "visible" : "hidden"; })
		.on("click", click)
		.append("title").text(function(d) {
			if(d.depth <= 0) return "100% (" + hyponymCount + ")"; 
			var ofTotal = parseFloat(d.hyponym_count) / hyponymCount
	  		return (ofTotal*100).toFixed(1) + " % (" + d.hyponym_count + " / " + hyponymCount + " )"
		});
}

function click(d) {
  	if (d.name != 'rest')
    	document.location = d.link;
}