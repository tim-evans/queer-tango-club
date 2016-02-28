class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :choose, :add_to_cart, :checkout, :purchase, :receipt, :members, :photos]

  def protocol
    if Rails.env.production?
      'https://'
    else
      'http://'
    end
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def choose
    if @event.registerable?
      @cart = session[:cart] || []
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
      if @event.is_a?(Workshop)
        flash[:error] = "Select workshops to attend."
      else
        flash[:error] = "Select events to attend."
      end
      redirect_to choose_event_url(@event, protocol: protocol)
    end
  end

  def checkout
    unless @event.registerable?
      redirect_to event_url(@event, protocol: protocol)
    end
  end

  def purchase
    if params[:name].blank?
      flash[:error] = "We require your name for registration"
      return redirect_to checkout_event_url(@event, protocol: protocol)
    end

    if params[:email].blank?
      flash[:error] = "We require your email for registration so we can send you a receipt"
      return redirect_to checkout_event_url(@event, protocol: protocol)
    end

    name = params[:name]
    email = params[:email]
    stripe_token = params[:stripe_token]

    member = Member.find_or_create_by(email: email)
    member.update_attributes(name: name)

    # Remove all sessions that a member has already signed up for
    sessions = Session.find(session[:cart]).to_a - member.sessions.to_a

    # Create an Order with Stripe and submit payment
    items = sessions.map do |session|
      {
        type: 'sku',
        amount: session.ticket_cost,
        currency: session.ticket_currency,
        parent: session.sku
      }
    end

    discounts = []
    workshops = sessions.select { |s| s.ticket_cost == 35_00 }
    milonga_queer = sessions.select { |s| s.ticket_cost == 20_00 }
    milonga_equinox = sessions.select { |s| s.ticket_cost == 15_00 }
    practicas = sessions.select { |s| s.ticket_cost == 10_00 }

    if milonga_queer.count == 2
      discounts << {
        type: 'discount',
        amount: -15_00,
        currency: 'usd',
        description: 'Pre-Milonga Class + Milonga Queer Discount'
      }
    end

    workshops.each do
      discounts << {
        type: 'discount',
        amount: -500,
        currency: 'usd',
        description: 'Early Bird Discount'
      }
    end

    case workshops.count
    when 3
      discounts << {
        type: 'discount',
        amount: -1000,
        currency: 'usd',
        description: 'Package deal'
      }
    when 4
      discounts << {
        type: 'discount',
        amount: -2000,
        currency: 'usd',
        description: 'Package deal'
      }
    end

    if milonga_equinox.count == 2
      discounts << {
        type: 'discount',
        amount: -12_00,
        currency: 'usd',
        description: 'Pre-Milonga Class + Milonga Equinox Discount'
      }
    end

    if milonga_queer.count == 2 &&
       workshops.count == 4 &&
       practicas.count == 2 &&
       milonga_equinox.count == 2
      discounts << {
        type: 'discount',
        amount: -13_00,
        currency: 'usd',
        description: 'Full Package discount'
      }
    end

    order = Stripe::Order.create(
      currency: 'usd',
      items: items + discounts,
      email: member.email
    )

    order = order.pay(source: stripe_token)

    base_url = if Rails.env.development?
                 "https://dashboard.stripe.com/orders/test"
               else
                 "https://dashboard.stripe.com/orders/"
               end

    sessions.each do |session|
      Attendee.create(
        member: member,
        session: session,
        payment_method: 'stripe',
        payment_currency: order.currency,
        payment_amount: order.amount,
        payment_url: "#{base_url}/#{order.id}",
        paid_at: order.created
      )
    end

    session.delete(:cart)
    session[:current_member_id] = member.id

    # Send the attendee an email
    charge = Stripe::Charge.retrieve(order.charge)
    charge.description = "Payment for #{@event.title}"
    charge.receipt_email = member.email
    charge.save

    redirect_to receipt_event_url(@event, protocol: protocol)
  rescue Stripe::CardError => e
    flash[:error] = e.json_body[:error][:message]
    return redirect_to checkout_event_url(@event, protocol: protocol)
  end

  def receipt
    @current_member = Member.find(session[:current_member_id])
  end

  def members
    redirect_to(event_path(@event)) unless current_user
  end

  def photos
    return redirect_to(event_path(@event)) unless current_user

    @photos = @event.photos.order(:created_at)
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end
end
