$(function () {
  if ($('#payment').length == 0) { return; }

  $('#card_number').payment('formatCardNumber');
  $('#card_expiration').payment('formatCardExpiry');
  $('#card_cvc').payment('formatCardCVC');

  var image = $('.credit-card.cvc').attr('src').replace("#cvc", '');

  $('#card_number').on('change', updateCardType);
  $('#card_number').on('keyup', updateCardType);

  function updateCardType() {
    var type = $.payment.cardType($('#card_number').val()) || 'unknown';
    $('.credit-card').attr('src', image + '#' + type);
    if (type === 'amex') {
      $('.credit-card.cvc').attr('src', image + '#amex-cvc');
    } else {
      $('.credit-card.cvc').attr('src', image + '#cvc');
    }
  }

  function isBlank(value) {
    return value == null || value === '' || (isNaN(value) && typeof(value) === 'number') || /^\s*$/.test(value);
  }

  function validate($form, data) {
    var errors = [];
    if (isBlank(data.name)) {
      errors.push('Enter the name as printed on your card.');
    }

    if (isBlank(data.number)) {
      errors.push('Enter your card number.');
    } else if (!$.payment.validateCardNumber(data.number)) {
      errors.push('The card number you provided is invalid.');
    }

    if (isBlank(data.cvc)) {
      errors.push("Enter your card's security code (the CVC).");
    }

    if (isBlank(data.exp_month) || isBlank(data.exp_year)) {
      errors.push("Enter the month and year when your card expires.");
    } else if (!$.payment.validateCardExpiry(data.exp_month, data.exp_year)) {
      errors.push('The card you provided has expired.');
    }

    if (errors.length) {
      $form.find('.payment-errors').html('<ul class="alert">' +
                                         errors.map(function (error) {
                                           return '<li class="alert-error">' + error + '</li>';
                                         }).join('') + '</ul>');
    }

    return errors.length === 0;
  }

  $('form').submit(function () {
    var $form = $(this);
    var expiry = $('#card_expiration').payment('cardExpiryVal');
    var data = {
      name: $('#cardholder_name').val(),
      number: $('#card_number').val(),
      cvc: $('#card_cvc').val(),
      exp_month: expiry.month,
      exp_year: expiry.year
    };

    if (!validate($form, data)) {
      return false;
    }

    $form.find('button').prop('disabled', true);
    Stripe.card.createToken(data, stripeResponseHandler);

    return false;
  });

  function stripeResponseHandler(status, response) {
    var $form = $('form');

    if (response.error) {
      // Show the errors on the form
      $form.find('.payment-errors').text(response.error.message);
      $form.find('button').prop('disabled', false);
    } else {
      // response contains id and card, which contains additional card details
      var token = response.id;
      // Insert the token into the form so it gets submitted to the server
      $form.append($('<input type="hidden" name="stripe_token" />').val(token));
      // and submit
      $form.get(0).submit();
    }
  }

  updateCardType();
});
