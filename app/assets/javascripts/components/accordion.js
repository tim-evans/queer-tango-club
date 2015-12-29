$(function () {
  var $element = $('.accordion');
  if (!$element.length) { return; }

  $element.each(function () {
    var id = $(this).data('accordion');
    var $el = $(this);
    var height = $('#' + id).height();;
    $('#' + id).css('overflow', 'hidden');
    var isLastChild = $('#' + id).index() === $(this).parent().children().length - 1;

    $(this).on('click', function () {
      $el.toggleClass('collapsed');

      if ($el.hasClass('collapsed')) {
        var margin = isLastChild ? 50 : 0;
        $('#' + id).animate({ height: 0, opacity: 0, marginBottom: margin }, 200);
      } else {
        $('#' + id).animate({ height: height, opacity: 1, marginBottom: 0 }, 200);
      }
    });
  });
});

