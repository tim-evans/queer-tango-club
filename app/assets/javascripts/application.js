//= require jquery
//= require_tree .
//= require_self

function icon(selector, value) {
  if (value == null) {
    return '<svg><use xlink:href="#' + selector + '"></svg>';
  } else {
    var el = $(selector).find('use')[0];
    el.setAttributeNS('http://www.w3.org/1999/xlink', 'href', '#' + value);
  }
}
