$(function () {
  var $element = $('.tab-bar');
  if (!$element.length) { return; }

  var tabs = $element.find('input').map(function () {
    return $(this).val();
  });

  function switchTab(id) {
    tabs.each(function (idx, tabId) {
      if (tabId === id) {
        $('#' + tabId).show();
      } else {
        $('#' + tabId).hide();
      }
    });
  }

  $element.on('change', 'input', function () {
    switchTab($element.find(':checked').val());
  });

  switchTab($element.find(':checked').val());
});
