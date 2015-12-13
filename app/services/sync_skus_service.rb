class SyncSkusService
  def intialize(event)
    @event = event
  end

  def sync!
    product = Stripe::Product.create(
      name: @event.name,
      active: true,
      description: @event.description,
      shippable: false,
      url: '' # use event_url(@event)
    )
    sku = Stripe::SKU.create(
      id: @event.sku,
      product: product.id,
      price: @event.ticket_cost,
      currency: @event.ticket_currency,
      inventory: {
        type: 'finite'
        quantity: @event.max_attendees
      }
    )

    Square::Item.create(
      name: @event.name,
      description: @event.description,
      variations: [{
        name: @event.name,
        sku: @event.sku
        price_money: {
          currency_code: @event.ticket_currency,
          amount: @event.ticket_cost
        }
      }]
    )
  end
end
