
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


// collapsible content our team page

var acc = document.getElementsByClassName("accordion");
var i;

for (i = 0; i < acc.length; i++) {
  acc[i].addEventListener("click", function() {
    /* Toggle between adding and removing the "active" class,
    to highlight the button that controls the panel */
    this.classList.toggle("active");

    /* Toggle between hiding and showing the active panel */
    var panel = this.nextElementSibling;
    if (panel.style.display === "block") {
      panel.style.display = "none";
    } else {
      panel.style.display = "block";
    }
  });
} 
