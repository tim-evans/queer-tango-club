class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :choose, :add_to_cart, :checkout, :purchase, :receipt, :publish, :unpublish]

  before_filter :authorize, only: [:new, :edit, :create, :update, :delete, :publish]
  before_filter :check_published, only: [:show, :choose, :add_to_cart, :checkout, :purchase, :receipt]

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

  def check_published
    if current_user || @event.published
      true
    else
      render file: "#{Rails.root}/app/views/errors/not_found.html" , status: :not_found
    end
  end

  def publish
    if @event.update_attributes({ published: true })
      redirect_to event_path(@event)
    end
  end

  def unpublish
    if @event.update_attributes({ published: false })
      redirect_to event_path(@event)
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
    @event.cover_photos.build
    @event.sessions.build
    @event.sessions.map(&:guests).flatten.map(&:teacher).uniq.each do |teacher|
      teacher.photos.build
    end
    @event.sessions.each do |session|
      session.guests.build
      session.guests.each do |guest|
        if guest.teacher.nil?
          guest.teacher = Teacher.new
          guest.teacher.photos.build
        end
      end
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.cover_photos.build
  end

  # POST /events
  def create
    @event = Event.new(event_params.merge(published: false))
    if @event.save
      redirect_to edit_event_path(@event)
    else
      redirect_to new_event_path, flash: { error: @event.errors.full_messages }
    end
  end

  # PUT /events
  def update
    if @event.update_attributes(event_params)
      redirect_to edit_event_path(@event), flash: { notice: "Saved #{@event.title}" }
    else
      redirect_to edit_event_path(@event), flash: { error: @event.errors.full_messages }
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
      @payment_amount = OrderService.new(
        @event.registerable_sessions.to_a
      ).total
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
    sessions = @event.sessions

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
    sessions = @event.sessions

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
      Attendee.create(
        member: member,
        session: session,
        payment_method: 'stripe',
        payment_currency: attribution.currency.to_s,
        payment_amount: attribution.fractional,
        payment_url: "#{base_url}/#{charge.id}",
        paid_at: DateTime.now
      )
    end

    session.delete(:cart)
    session[:current_member_id] = member.id

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
      params.require(:event).permit(:title, :starts_at, :ends_at, :description, {
        cover_photos_attributes: [:id, :attachment, :title, :_destroy],
        sessions_attributes: [:id, :title, :starts_at, :ends_at, :description, :location_id, :display_cost, :max_attendees, {
          guests_attributes: [:id, :teacher_id, :role, {
            teacher_attributes: [:id, :name, :bio, :url, {
              photos_attributes: [:id, :attachment]
            }]
          }]
        }]
      }).tap do |params|
        # Remove an unfilled session
        if params[:sessions_attributes]
          new_session = params[:sessions_attributes].values.find { |session| session[:id].blank? }
          if [:title, :starts_at, :ends_at].all? { |key| new_session[key].blank? }
            params[:sessions_attributes].delete(
              params[:sessions_attributes].key(new_session)
            )
          end

          params[:sessions_attributes].each do |_, session_params|
            session_params[:guests_attributes].each do |idx, guest_params|
              if [:role, :teacher_id].all? { |key| guest_params[key].blank? }
                params[:sessions_attributes][params[:sessions_attributes].key(session_params)][:guests_attributes].delete(idx)
              else
                guest_params.tap do |guest_params|
                  if guest_params[:teacher_attributes][:id].present? &&
                     guest_params[:teacher_id] != guest_params[:teacher_attributes][:id]
                    guest_params.delete(:teacher_attributes)
                  end
                end
              end
            end
          end
        end
      end
    end
end
