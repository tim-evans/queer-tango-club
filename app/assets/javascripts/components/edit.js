$(function () {
  // Preview files that are added
  $('form input[type="file"]').on('change', function (evt) {
    var element = evt.target;
    $(element).parent().hide(200);
    var reader = new FileReader();
    reader.onload = function () {
      if ($('.cover-photo:visible').length) {
        var top = $('.cover-photo:visible').offset().top + $('.cover-photo').height();
        $('html,body').animate({ scrollTop: top }, 500, function () {
          $('.preview').show(500);
        });
      } else {
        $('.preview').show(500);
      }
      $('.preview > div').html('<img src="' + reader.result + '"/>');
    }
    reader.readAsDataURL(element.files[0]);
  });

  $('.add-session').on('click', function () {
    $('.session-form:last-child').show();
    $('.add-session').hide(200);
    var top = $('.session-form:last-child').offset().top + $('.session-form:last-child').height();
    $('html,body').animate({ scrollTop: top }, 500);
  });
});
