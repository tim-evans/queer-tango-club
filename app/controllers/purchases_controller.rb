class PurchasesController < ApplicationController

  def create
    customer = params[:data][:attributes]
    sessions = group.sessions.find(
      params[:data][:relationships][:data][:sessions].map { |s| s[:id] }
    )

    if customer[:name].blank?
      flash[:error] = "We require your name for registration"
      return redirect_to checkout_event_url(@event, protocol: protocol)
    end

    if params[:email].blank? && params[:payment_method] == 'stripe'
      flash[:error] = "We require your email for registration so we can send you a receipt"
      return redirect_to checkout_event_url(@event, protocol: protocol)
    end

    if customer[:payment_method] == 'cash' && current_user
      pay_with_cash(customer, sessions)
    elsif customer[:payment_method] == 'gratis' && current_user
      pay_nothing(customer, sessions)
    else
      pay_with_stripe(customer, sessions)
    end
  end

  private

  def pay_with_cash(customer, sessions)
    member = if customer[:email].present?
               Member.find_or_create_by(email: customer[:email])
             else
               Member.find_or_create_by(name: customer[:name])
             end
    member.update_attributes(name: customer[:name])

    # Remove all sessions that a member has already signed up for
    sessions = sessions.where.not(id: member.sessions.pluck(:id))

    cash = Monetize.parse(customer[:payment_amount], 'USD')
    order = OrderService.new(sessions)

    order.final_attribution(cash).each do |session, attribution|
      transaction = Transaction.create(
        description: "##{session.id} / #{session.title}",
        paid_at: DateTime.now,
        paid_by: member.name,
        amount: attribution.fractional,
        currency: attribution.currency.to_s,
        method: 'cash',
        notes: "Part of an order with the following other items:\n#{sessions.map(&:title).join('\n')}"
      )

      Attendee.create(
        member: member,
        session: session,
        transaction: transaction
      )
    end

    OrderMailer.confirmation_email(member, order).deliver!
    head :created
  end

  def pay_nothing(customer, sessions)
    member = if customer[:email].present?
               Member.find_or_create_by(email: customer[:email])
             else
               Member.find_or_create_by(name: customer[:name])
             end
    member.update_attributes(name: customer[:name])

    # Remove all sessions that a member has already signed up for
    sessions = sessions.where.not(id: member.sessions.pluck(:id))

    cash = Monetize.parse(customer[:payment_amount], 'USD')
    order = OrderService.new(sessions)

    sessions.each do |session|
      transaction = Transaction.create(
        description: "##{session.id} / #{session.title}",
        paid_at: DateTime.now,
        paid_by: member.name,
        amount: 0,
        currency: 'usd',
        method: 'gratis',
        notes: "Part of an order with the following other items:\n#{sessions.map(&:title).join('\n')}"
      )

      Attendee.create(
        member: member,
        session: session,
        transaction: transaction
      )
    end

    head :created
  end

  def pay_with_stripe(customer, sessions)
    stripe_token = customer[:stripe_token]

    member = Member.find_or_create_by(email: customer[:email])
    member.update_attributes(name: customer[:name])

    # Remove all sessions that a member has already signed up for
    sessions = sessions.where.not(id: member.sessions.pluck(:id))

    order = OrderService.new(sessions, stripe: true)
    charge = Stripe::Charge.create({
      currency: order.total.currency,
      amount: order.total.fractional,
      receipt_email: member.email,
      description: "Payment for #{@event.title}",
      metadata: {
        name: member.name,
        email: member.email,
        sessions: sessions.map(&:title).join(', ')
      },
      source: stripe_token
    })

    base_url = if Rails.env.development?
                 "https://dashboard.stripe.com/test/payments"
               else
                 "https://dashboard.stripe.com/payments"
               end

    balance = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)
    net_total = Money.new(balance.net, balance.currency)

    order.final_attribution(net_total).each do |session, attribution|
      transaction = Transaction.create(
        description: "##{session.id} / #{session.title}",
        paid_at: DateTime.now,
        paid_by: member.name,
        amount: attribution.fractional,
        currency: attribution.currency.to_s,
        method: 'stripe',
        url: "#{base_url}/#{charge.id}",
        notes: "Part of an order with the following other items:\n#{sessions.map(&:title).join('\n')}"
      )

      Attendee.create(
        member: member,
        session: session,
        transaction: transaction
      )
    end

    OrderMailer.confirmation_email(member, order).deliver!
    head :created
  rescue Stripe::CardError => e
    flash[:error] = e.json_body[:error][:message]
    return redirect_to checkout_event_url(@event, protocol: protocol)
  end
end
