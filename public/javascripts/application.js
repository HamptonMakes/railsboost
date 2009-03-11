// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(function() {
  // do this whenever a checkbox is hit
  $("input[type=checkbox]").change(function(event) {
    
    // load up my references
    var input = $(event.target)
    var parentWrapper = input.parent()
    var requiredCommandDiv = parentWrapper.children(".requirements")
    var requiredCommandInputs = requiredCommandDiv.children("input")
    
    // Make the other boxes check/uncheck with this one
    // $("input[value=" + input.val() + "]").attr({checked: input.attr("checked")})
    
    // Fix up the required commands
    if(input.attr("checked")) {
      requiredCommandDiv.show()
      console.log(requiredCommandDiv)
      requiredCommandInputs.attr({checked: true})
    } else {
      //requiredCommandDiv.hide()
      requiredCommandInputs.attr({checked: false})
    }
    
  })
  
  $("input[type=checkbox]").change()
  
  $("#app_name_field").keyup(function(event) {
    $("#app_name").html($(event.target).val());
  }).keyup();
})