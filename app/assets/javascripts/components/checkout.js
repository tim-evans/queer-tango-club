$(function () {
  if ($('#payment').length == 0) { return; }

  $('#card_number').payment('formatCardNumber');
  $('#card_expiration').payment('formatCardExpiry');
  $('#card_cvc').payment('formatCardCVC');

  $('#card_number').on('change', updateCardType);
  $('#card_number').on('keyup', updateCardType);

  function updateCardType() {
    var type = $.payment.cardType($('#card_number').val()) || 'other';
    icon('.credit-card:first', type);
    if (type === 'amex') {
      icon('.credit-card.cvc', 'amex-cvv');
    } else {
      icon('.credit-card.cvc', 'cvv');
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
                                           return '<li class="alert-error">' + icon('alert-solid') + error + '</li>';
                                         }).join('') + '</ul>');
    }

    return errors.length === 0;
  }

  $('form').submit(function () {
    var paymentMethod = $('input[name="payment_method"]:checked').val();
    if (paymentMethod === 'cash' ||
        paymentMethod === 'gratis') {
      return true;
    }

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
