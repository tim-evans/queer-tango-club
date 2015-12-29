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

  $('form').submit(function () {
    var $form = $(this);

    $form.find('button').prop('disabled', true);
    var expiry = $('#card_expiration').payment('cardExpiryVal');
    Stripe.card.createToken({
      number: $('#card_number').val(),
      cvc: $('#card_cvc').val(),
      exp_month: expiry.month,
      exp_year: expiry.year
    }, stripeResponseHandler);

    return false;
  });

  function stripeResponseHandler(status, response) {
    var $form = $('form');

    if (response.error) {
      // Show the errors on the form
      $form.find('.errors').text(response.error.message);
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
});
