$("#glossary h2").each(function(index) {
  // Get the word and its definition.
  var word = $(this).text();
  var def = $("#glossary").find("p")[index].innerHTML;

  // Update all instances of that word in the content page with mouse over def.
  var ids = ["#content1", "#content2", "#content3"];
  for (i = 0; i < ids.length; i++) {
    var contentHTML = $(ids[i]).html();
    // var contentHTML = $(".content").html();
    // contentHTML = contentHTML.replace(new RegExp(word, 'g'), '<span class="tooltip">' + word + '<span class="tooltiptext">' + def + '</span></span>');
    if(contentHTML != undefined){
      contentHTML = contentHTML.replace(new RegExp(word, 'g'), '<span class="tooltip">' + word + '<span class="tooltiptext">' + def + '</span></span>');
      $(ids[i]).html(contentHTML);
    }
  }
});
