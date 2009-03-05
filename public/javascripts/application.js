// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(function() {
  $("input[type=checkbox]").change(function(event) {
    var input = $(event.target)
    var parentWrapper = input.parent()
    var requiredCommandDiv = parentWrapper.children(".requirements")
    var requiredCommandInputs = requiredCommandDiv.children("input[type=checkbox]")
    
    if(input.attr("checked")) {
      requiredCommandDiv.show()
      requiredCommandInputs.attr({checked: true})
    } else {
      requiredCommandDiv.hide()
      requiredCommandInputs.attr({checked: false})
    }
    
  })
})