//= require prototype
//= require effects
//= require dragdrop
//= require controls
//= require yui-min
//= require d3.v2
//= require_tree .
//= require_self

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function gotoWord(word, filter) {
  if(word == undefined || word == null || word == "") { location.href = '/wordties-dannet/spelling/empty'; return; }
  else { location.href = '/wordties-dannet/find/' + filter + '/' + word; }
}
