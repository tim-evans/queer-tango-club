class SquareWebhookService
  def receive(request)
    body = request.body.string
    signature = request.env['HTTP_X_SQUARE_SIGNATURE']

    if signature_valid?(body, signature)
      puts 'Webhook with invalid signature detected'
      return
    end

    json = JSON.parse(body)
    return unless handles_request?(json)

    order = retrieve_order_summary(json['entity_id'])

    member = Member.create_with(name: order[:name])
                   .find_or_create_by(email: payment[:email])

    # Create attendees for each of the classes bought
    order[:skus].each do |sku|
      attendee = Attendee.create(
        payment_method: 'Square',
        payment_url: payment_json['payment_url'],
        paid_at: Time.parse(payment_json['created_at']),
      )
      attendee.member = member
      attendee.workshop = Class.find_by_sku(sku)
      attendee.save!
    end
  end

  WEBHOOK_URL = 'http://api.queertangoclub.nyc/webhooks/square'

  def signature_valid?(body, signature)
    string_to_sign = WEBHOOK_URL + body

    generated_signature = Base64.strict_encode64(
      OpenSSL::HMAC.digest('sha1', ENV['SQUARE_SIGNATURE_KEY'], string_to_sign)
    )

    Digest::SHA1.base64digest(generated_signature) == Digest::SHA1.base64digest(signature)
  end

  # Only handle PAYMENT_UPDATED webhooks
  def handles_request?(json)
    json.has_key?('event_type') && json['event_type'] === 'PAYMENT_UPDATED'
  end

  def retrieve_order_summary(payment_id)
    payment = Unirest.get("https://connect.squareup.com/v1/me/payments/#{payment_id}",
                          headers: {
                            'Authorization': "Bearer #{ENV['SQUARE_ACCESS_TOKEN']}",
                            'Accept': 'application/json',
                            'Content-Type': 'application/json'
                          })
    payment_json = JSON.parse(payment.body)

    order = Unirest.get("https://connect.squareup.com/v1/me/orders?payment_id=#{payment_id}",
                        headers: {
                          'Authorization': "Bearer #{ENV['SQUARE_ACCESS_TOKEN']}",
                          'Accept': 'application/json',
                          'Content-Type': 'application/json'
                        })
    order_json = JSON.parse(order.body)

    {
      payment_url: payment_json['payment_url'],
      paid_at: Time.parse(payment_json['created_at']),
      name: order_json['recipient_name'],
      email: order_json['buyer_email'],
      skus: payment_json['itemizations'].map { |item| item['item_detail']['sku'] }
    }
  end
end
