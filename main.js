

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


$("#glossary h2").each(function(index) {
  // Get the word and its definition.
  var word = $(this).text();
  var def = $("#glossary").find("p")[index].innerHTML;

  // Update all instances of that word in the content page with mouse over def.
  var contentHTML = $("#content").html();
  contentHTML = contentHTML.replace(new RegExp(word, 'g'), '<div class="tooltip">' + word + '<span class="tooltiptext">' + def + '</span></div>');

  // contentHTML = contentHTML.replace(new RegExp(word, 'g'), '<span title="' + def + '">' + word + '</span>');
  $("#content").html(contentHTML);
});