class Webhooks::SquareController < ActionController::Base

  WEBHOOK_URL = 'http://api.queertangoclub.nyc/webhooks/square'

  def receive(request)
    unless valid_request?(request)
      puts 'Webhook with invalid signature detected'
      head :bad_request
    end

    json = JSON.parse(request.body.string)
    event_type = json['event_type'].try(:downcase)
    if event_type && self.respond_to?(event_type)
      self.send(event_type, json)
    end
    head :ok
  end

  def payment_updated(json)
    order = retrieve_order_summary(json['entity_id'])

    member = Member.create_with(name: order[:buyer_name])
                   .find_or_create_by(email: payment[:buyer_email])

    # Create attendees for each of the classes bought
    order[:skus].each do |sku|
      attendee = Attendee.create(
        payment_method: 'Square',
        payment_url: order[:payment_url],
        paid_at: Time.parse(order[:paid_at]),
      )
      attendee.member = member
      attendee.workshop = Class.find_by_sku(sku)
      attendee.save!
    end
  end

  def valid_request?(request)
    body = request.body.string
    signature = request.env['HTTP_X_SQUARE_SIGNATURE']
    string_to_sign = WEBHOOK_URL + body

    generated_signature = Base64.strict_encode64(
      OpenSSL::HMAC.digest('sha1', ENV['SQUARE_SIGNATURE_KEY'], string_to_sign)
    )

    Digest::SHA1.base64digest(generated_signature) == Digest::SHA1.base64digest(signature)
  end

  def retrieve_order_summary(payment_id)
    payment = Square::Payment.retrieve(payment_id)
    orders = Square::Order.list(order: 'DESC')
    order = orders.find { |order| order.payment_id == payment_id }

    {
      payment_url: payment.payment_url,
      paid_at: Time.parse(payment.created_at),
      buyer_name: order.recipient_name,
      buyer_email: order.buyer_email,
      skus: payment.itemizations.map { |item| item.item_detail.sku }
    }
  end
end
