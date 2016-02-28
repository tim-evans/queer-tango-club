$(function () {
  var $element = $('.hero-image');
  if (!$element.length) { return; }
  var element = $element[0];

  var getImageSize = (function () {
    return function (success) {
      let $img = $element.find('img');
      success({
        width: $img.attr('width'),
        height: $img.attr('height')
      });
    };
  }())

  function onresize() {
    var display = element.style.display;
    element.style.display = 'none';
    var height = $(document).height();
    element.style.display = display;

    tile({
      height: height,
      width: window.innerWidth
    });
  }

  function tile(windowSize) {
    var width = windowSize.width;
    var height = windowSize.height;
    var hero = element;
    var display = hero.style.display;
    hero.style.display = 'none';

    hero.style.display = display;
    hero.style.height = height + 'px';
    hero.style.width = width + 'px';

    getImageSize(function (imageSize) {
      var scale;
      if ((width / height) > (imageSize.width / imageSize.height)) {
        scale = width / imageSize.width;
      } else {
        scale = height / imageSize.height;
      }

      var margin = width - (imageSize.width * scale);
      $element.find('img').css({
        height: (imageSize.height * scale) + 'px',
        width: (imageSize.width * scale) + 'px',
        marginLeft: (margin / 2) + 'px'
      });
    });
  }

  $(window).on('resize', onresize);
  $(window).bind('orientationchange', function(event) {
    onresize();
  });
  onresize();
});

