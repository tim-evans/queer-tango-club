$(function () {
  var $element = $('.guest');
  if (!$element.length) { return; }

  $element.each(function () {
    if ($(this).find('.guest-photos img').length > 1) { return; }

    var bio = $(this).find('.bio');
    var summary = bio.find('p:first-child');
    var extendedBio = bio.find('p:not(:first-child)');
    var isShowing = false;

    extendedBio.hide();
    $(summary).on('click', function () {
      if (isShowing) {
        extendedBio.hide();
      } else {
        extendedBio.show();
      }
      isShowing = !isShowing;
    });
  });
});

