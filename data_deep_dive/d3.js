// set the dimensions and margins of the graph
var margin = {top: 10, right: 30, bottom: 50, left: 60},
    width = 460 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// append the svg object to the body of the page
var svg = d3.select("#my_dataviz")
  .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

//Read the data
d3.csv("../data-for-china/china_death_so2.csv", function(data) {

  // Add X axis
  var x = d3.scaleLinear()
    .domain([0, 70])
    .range([ 0, width ]);
  svg.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x));

  // Add Y axis
  var y = d3.scaleLinear()
    .domain([0, 14])
    .range([ height, 0]);
  svg.append("g")
    .call(d3.axisLeft(y));

  // Add dots
  svg.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
      .attr("cx", function (d) { return x(d.SO2); } )
      .attr("cy", function (d) { return y(d.Death_rate); } )
      .attr("r", 1.5)
      .style("fill", "#69b3a2")

  // Add X axis label:
  svg.append("text")
      .attr("text-anchor", "end")
      .attr("x", width/2 + margin.left + 90)
      .attr("y", height + margin.top + 35)
      .text("SO2 Level (micrograms per cubic meter)");

  // Y axis label:
  svg.append("text")
      .attr("text-anchor", "end")
      .attr("transform", "rotate(-90)")
      .attr("y", -margin.left + 25)
      .attr("x", -margin.top - height/2 + 90)
      .text("Covid 19 Death Rate (%)")

})
