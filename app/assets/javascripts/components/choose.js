$(function () {
  if ($('#itemizations').length == 0) { return; }
  $('input').on('change', function () {
    calculate();
  });

  function calculate () {
    var items = $('form').serializeArray();
    var numberItems = 0;
    for (var i = 0, len = items.length; i < len; i++) {
      if (items[i].name.indexOf("sessions") === 0) {
        numberItems++;
      }
    }

    var subtotal = numberItems * 35;
    var discounts = 0;

    switch (numberItems) {
    case 3:
      discounts = subtotal - 80;
      break;
    case 4:
      discounts = subtotal - 100;
      break;
    default:
      discounts = numberItems * 5;
      break;
    }
    $('#subtotal').html('$' + subtotal);
    $('#discounts').html('-$' + discounts);
    $('#total').html('$' + (subtotal - discounts));
  }

  calculate();
});
