class SyncSkusService
  include Rails.application.routes.url_helpers

  def initialize(session)
    @session = session
  end

  def create!
    product = Stripe::Product.create(
      name: @session.title,
      active: true,
      description: @session.description,
      shippable: false,
      url: event_url(@session.event)
    )
    sku = Stripe::SKU.create(
      product: product.id,
      price: @session.ticket_cost,
      currency: @session.ticket_currency,
      inventory: {
        type: 'finite',
        quantity: @session.max_attendees
      }
    )
    @session.update_attributes(sku: sku.id)
  end
end
