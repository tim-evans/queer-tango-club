class Webhooks::SquareController < ApplicationController

  protect_from_forgery except: :receive

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
    payment = Square::Payment.retrieve(json['entity_id'])
    skus = payment.itemizations.map { |item| item.item_detail.sku }

    notes = payment.itemizations.map { |item| item.notes }.compact
    # Notes may include the user's name or email
    email = notes.find { |note| note.include?('@') }
    name = notes.find { |note| !note.include?('@') }
    member = if email
               Member.find_or_create_by(email: email.strip)
             elsif name
               Member.find_or_create_by(name: name.strip)
             else
               Member.create
             end

    # Create members / attendees for each of the classes bought
    skus.each do |sku|
      event = Event.find_by_sku(sku)
      next if Attendee.where(member_id: member.id,
                             event_id: event.id).count

      Attendee.create(
        payment_method: 'square',
        payment_url: payment.payment_url,
        paid_at: Time.parse(payment.created_at),
        member: member,
        event: event
      )
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
  end
end
