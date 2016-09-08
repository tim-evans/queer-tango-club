class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :choose, :add_to_cart, :checkout, :purchase, :receipt]

  before_filter :authorize, only: [:new, :edit, :create, :update, :delete]

  def protocol
    if Rails.env.production?
      'https://'
    else
      'http://'
    end
  end

  def authorize
    if current_user
      true
    else
      render file: "#{Rails.root}/app/views/errors/not_found.html" , status: :not_found
    end
  end

  def index
    if current_user
      @events = Event.all.order(starts_at: :desc)
    else
      @events = Event.published.order(starts_at: :desc)
    end
  end

  # GET /events/1
  def show
  end

  # GET /events/1/edit
  def edit
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # POST /events
  def create
    @event = Event.new(event_params.merge(published: false))
    if @event.save
      redirect_to event_path(@event)
    end
  end

  def choose
    if current_user || @event.registerable?
      @cart = session[:cart] || []
      @smart_collapse = @event.highlight? && @event.sessions.any?(&:highlight?) && current_user
      @sessions_by_day = @event.sessions_by_day.map do |sessions|
        if current_user
          sessions.select { |session| session.ticket_cost.present? }
        else
          sessions.select(&:registerable?)
        end
      end
      @sessions_by_day = @sessions_by_day.select do |sessions|
        sessions.size > 0
      end
    else
      redirect_to event_url(@event, protocol: protocol)
    end
  end

  def add_to_cart
    if params[:sessions]
      session_ids = params[:sessions].keys
      sessions = Session.find(session_ids).to_a
      has_overlapping_sessions = sessions.any? do |session|
        (sessions - [session]).any? do |other|
          session.overlaps?(other)
        end
      end

      if has_overlapping_sessions
        session.delete(:cart)
        flash[:error] = "Select events that don't overlap."
        redirect_to choose_event_url(@event, protocol: protocol)
      else
        session[:cart] = session_ids
        redirect_to checkout_event_url(@event, protocol: protocol)
      end
    else
      session.delete(:cart)
      flash[:error] = "Select classes to attend."
      redirect_to choose_event_url(@event, protocol: protocol)
    end
  end

  def checkout
    if @event.registerable? || current_user
      @payment_amount = OrderService.new(Session.where(id: session[:cart])).total
    else
      redirect_to event_url(@event, protocol: protocol)
    end
  end

  def pay_with_cash
    name = params[:name]
    email = params[:email]

    member = if email.present?
               Member.find_or_create_by(email: email)
             else
               Member.find_or_create_by(name: name)
             end
    member.update_attributes(name: name)

    # Remove all sessions that a member has already signed up for
    sessions = Session.where(id: session[:cart]).where.not(id: member.sessions.pluck(:id))

    cash = Monetize.parse(params[:payment_amount], 'USD')
    order = OrderService.new(sessions)

    order.final_attribution(cash).each do |session, attribution|
      Attendee.create(
        member: member,
        session: session,
        payment_method: 'cash',
        payment_currency: attribution.currency.to_s,
        payment_amount: attribution.fractional,
        paid_at: DateTime.now
      )
    end

    session.delete(:cart)
    session[:current_member_id] = member.id

    OrderMailer.confirmation_email(member, order).deliver!
    redirect_to event_members_path(@event)
  end

  def pay_nothing
    name = params[:name]
    email = params[:email]

    member = if email.present?
               Member.find_or_create_by(email: email)
             else
               Member.find_or_create_by(name: name)
             end
    member.update_attributes(name: name)

    # Remove all sessions that a member has already signed up for
    sessions = Session.where(id: session[:cart]).where.not(id: member.sessions.pluck(:id))
    sessions.each do |session|
      Attendee.create(
        member: member,
        session: session,
        payment_method: 'gratis',
        payment_currency: 'usd',
        payment_amount: 0,
        paid_at: DateTime.now
      )
    end

    session.delete(:cart)
    session[:current_member_id] = member.id

    redirect_to event_members_path(@event)
  end

  def pay_with_stripe
    name = params[:name]
    email = params[:email]

    stripe_token = params[:stripe_token]

    member = Member.find_or_create_by(email: email)
    member.update_attributes(name: name)

    # Remove all sessions that a member has already signed up for
    sessions = Session.where(id: session[:cart]).where.not(id: member.sessions.pluck(:id))

    order = OrderService.new(sessions)
    stripe_order = Stripe::Order.create(
      currency: 'usd',
      items: order.stripe_itemizations,
      email: member.email
    )

    paid_order = stripe_order.pay(source: stripe_token)

    base_url = if Rails.env.development?
                 "https://dashboard.stripe.com/orders/test"
               else
                 "https://dashboard.stripe.com/orders"
               end

    charge = Stripe::Charge.retrieve(paid_order.charge)
    balance_transaction = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)
    net_total = Money.new(balance_transaction.net, balance_transaction.currency)

    order.final_attribution(net_total).each do |session, attribution|
      Attendee.create(
        member: member,
        session: session,
        payment_method: 'stripe',
        payment_currency: attribution.currency.to_s,
        payment_amount: attribution.fractional,
        payment_url: "#{base_url}/#{stripe_order.id}",
        paid_at: DateTime.now
      )
    end

    session.delete(:cart)
    session[:current_member_id] = member.id

    # Send the attendee an email
    charge = Stripe::Charge.retrieve(paid_order.charge)
    charge.description = "Payment for #{@event.title}"
    charge.receipt_email = member.email
    charge.save

    OrderMailer.confirmation_email(member, order).deliver!
    redirect_to receipt_event_url(@event, protocol: protocol)
  rescue Stripe::CardError => e
    flash[:error] = e.json_body[:error][:message]
    return redirect_to checkout_event_url(@event, protocol: protocol)
  end

  def purchase
    if params[:name].blank?
      flash[:error] = "We require your name for registration"
      return redirect_to checkout_event_url(@event, protocol: protocol)
    end

    if params[:email].blank? && params[:payment_method] == 'stripe'
      flash[:error] = "We require your email for registration so we can send you a receipt"
      return redirect_to checkout_event_url(@event, protocol: protocol)
    end

    if params[:payment_method] == 'cash' && current_user
      pay_with_cash
    elsif params[:payment_method] == 'gratis' && current_user
      pay_nothing
    else
      pay_with_stripe
    end
  end

  def receipt
    @current_member = Member.find(session[:current_member_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.where(id: params[:id]).includes({
        sessions: [{
          guests: { teacher: :photos },
          location: :nearby_locations
        }],
      },
      :cover_photos, :photos).first
      raise ActiveRecord::RecordNotFound.new if @event.nil?
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title)
    end
end
