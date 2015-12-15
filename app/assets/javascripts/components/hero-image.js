$(function () {
  var $element = $('.hero-image');
  if (!$element.length) { return; }
  var element = $element[0];

  function loadImage(src, success, error) {
    var image = new Image();
    image.onload = function () {
      success({
        width: image.width,
        height: image.height
      });
    };
    image.onerror = error;
    image.src = src;
  }

  var getImageSize = (function () {
    var size = null;
    return function (success) {
      if (size) { return success(size); }

      loadImage($element.find('img').attr('src'), function (imageSize) {
        success(imageSize);
      }, function () {});
    };
  }())

  function onresize() {
    tile({
      height: $(document).height(),
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

