$(function () {
  if (!$('.admin').length && !$('.toggle-attended').length) { return; }

  function setAttended($checkbox) {
    var data = {
      attendee: {
        attended: !$checkbox.data('attended')
      }
    };
    data[$('meta[name="csrf-param"]').attr('content')] = $('meta[name="csrf-token"]').attr('content');

    icon($checkbox, 'spinner');

    $.ajax({
      url: '/attendees/' + $checkbox.data('id'),
      method: 'put',
      data: data
    }).then(function (result) {
      if (result.attendee.attended) {
        icon($checkbox, 'check-solid');
      } else {
        icon($checkbox, 'check');
      }
      $checkbox.data("attended", result.attendee.attended);
    });
  }

  $('.toggle-attended').on('click', function (evt) {
    setAttended($(this));
    evt.preventDefault();
  });

  if ($(window).width() <= 500) {
    $('.table .flex-row').on('click', function (evt) {
      setAttended($(this).find('.toggle-attended'));
    });
  }

});
