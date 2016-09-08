$(function () {
  if (!$('.admin').length && !$('.toggle-attended').length) { return; }

  $('.toggle-attended').on('click', function (evt) {
    var $checkbox = $(this);
    var data = {
      attendee: {
        attended: !$checkbox.data('attended')
      }
    };
    data[$('meta[name="csrf-param"]').attr('content')] = $('meta[name="csrf-token"]').attr('content');

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
    evt.preventDefault();
  });
});
