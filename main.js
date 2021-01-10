// Define a Function
function sayOuch() {
	alert('Hey, you just clicked the logo!');
}

// Use a CSS selector to identify an element
var logo = document.querySelector('img');

// Assign the function to the onclick event on that element
logo.onclick = sayOuch;


// Include literature review table
d3.text("lit_review_table.csv", function(data) {
    var parsedCSV = d3.csv.parseRows(data);

    var container = d3.select("#lit_review")
        .append("table")

        .selectAll("tr")
            .data(parsedCSV).enter()
            .append("tr")

        .selectAll("td")
            .data(function(d) { return d; }).enter()
            .append("td")
            .text(function(d) { return d; });
});
