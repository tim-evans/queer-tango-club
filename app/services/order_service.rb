class OrderService

  attr_reader :sessions, :event

  def initialize(sessions, at: DateTime.now)
    @sessions = sessions
    @event = sessions.first.event
    @discounts = @event.discounts
    @ordered_at = at
  end

  def stripe_itemizations
    items = @sessions.map do |session|
      {
        type: 'sku',
        amount: session.ticket_cost,
        currency: session.ticket_currency.downcase,
        parent: session.sku
      }
    end

    discounts = @discounts.select do |discount|
      discount.apply_to?(@sessions, at: @ordered_at).size > 0
    end

    items + discounts.map do |discount|
      {
        type: 'discount',
        amount: discount.fractional,
        currency: discount.currency.downcase,
        description: discount.description
      }
    end
  end

  def price_of(session)
    attribution[session]
  end

  def attribution
    attribution = {}
    @sessions.each do |session|
      attribution[session] = session.cost
    end

    @discounts.each do |discount|
      sessions = discount.apply_to?(@sessions, at: @ordered_at)
      discount_amount = if sessions.count > 0
                          discount.amount
                        else
                          Money.new(0, discount.currency)
                        end

      if discount.distribute_among
        sessions = sessions.select { |session| discount.distribute_among.include?(session.id) }
      end

      sessions.each do |session|
        attribution[session] = attribution[session] + (discount_amount / sessions.size)
      end
    end

    attribution
  end

  def total
    attribution.values.reduce(Money.new(0, 'USD')) do |total, item|
      total + item
    end
  end

  def final_attribution(amount_paid)
    difference = amount_paid - total
    fraction = difference / attribution.keys.size

    if difference.zero?
      attribution
    else
      attribution.reduce({}) do |acc, (key, value)|
        acc[key] = value + fraction
        acc
      end
    end
  end
end
