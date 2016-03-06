$(function () {
  if ($('#itemizations').length == 0) { return; }
  $('input').on('change', function () {
    var simultaneousEvent = $('input:checked[data-starts-at="' + $(this).data('starts-at') + '"]:not(#' + $(this).attr('id') + ')');

    if (simultaneousEvent) {
      simultaneousEvent.attr('checked', null);
    }
    calculate();
  });

  function calculate () {
    var items = $('form').serializeArray();
    var numberItems = 0;
    var subtotal = 0;
    var invoiceItems = [];

    for (var i = 0, len = items.length; i < len; i++) {
      if (items[i].name.indexOf("sessions") === 0) {
        var $item = $('input[name="' + items[i].name + '"]');
        var invoiceItem = {
          amount: $item.data('amount') / 100,
          startsAt: $item.data('starts-at'),
          endsAt: $item.data('ends-at')
        };
        invoiceItems.push(invoiceItem);
        subtotal += invoiceItem.amount;
      }
    }

    // Workshops discounts
    var discounts = 0;
    var milongaQueer = invoiceItems.filter(function (item) { return item.amount === 20 });
    var milongaEquinox = invoiceItems.filter(function (item) { return item.amount === 15 });

    // Class + Milonga has a discount; separately, they are the same
    if (milongaQueer.length === 2) {
      discounts += 15;
    }

    if (milongaEquinox.length === 2) {
      discounts += 12;
    }

    $('#subtotal').html('$' + subtotal);
    $('#discounts').html('-$' + discounts);
    $('#total').html('$' + (subtotal - discounts));
  }

  calculate();
});
