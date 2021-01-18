$("#glossary h2").each(function(index) {
  // Get the word and its definition.
  var word = $(this).text();
  var def = $("#glossary").find("p")[index].innerHTML;

  // Update all instances of that word in the content page with mouse over def.

  // var elements = $("[id^=content]").toArray() //array of elements with ids starting with "content"
  // for (i = 0; i < elements.length; i++) {
    
  // // get content matching ID
  //   var contentHTML = $("#"+elements[i].id).html();
    
    // test to make sure element was found

  var ids = ["#content1", "#content2", "#content3", "#content4", "#content5", "#content6", "#content7", "#content8", "#content9"];
  for (i = 0; i < ids.length; i++) {
    var contentHTML = $(ids[i]).html();
    // var contentHTML = $(".content").html();
    // contentHTML = contentHTML.replace(new RegExp(word, 'g'), '<span class="tooltip">' + word + '<span class="tooltiptext">' + def + '</span></span>');

    if(contentHTML != undefined){
      // replace glossary words with the tooltip span
      contentHTML = contentHTML.replace(new RegExp(word, 'g'), '<span class="tooltip">' + word + '<span class="tooltiptext">' + def + '</span></span>');
      $(ids[i]).html(contentHTML);
      // $("#"+elements[i].id).html(contentHTML);
    }
  }
});
