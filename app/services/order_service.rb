class OrderService

  attr_reader :sessions, :event

  def initialize(sessions, at: DateTime.now, stripe: false)
    @sessions = sessions
    @event = @sessions.compact.first.event
    @discounts = @event.discounts
    @ordered_at = at
    @stripe = stripe
  end

  def price_of(session)
    attribution[session]
  end

  def attribution
    attribution = {}
    discount_amount = Money.new(0_00, 'USD')
    total = if @event.id == 50
              Money.new(50_00, 'USD')
            elsif @event.id == 49
              Money.new(80_00, 'USD')
            else
              Money.new(25_00, 'USD')
            end

    @sessions.each do |session|
      attribution[session] = total + (discount_amount / @sessions.size)
    end

    attribution
  end

  def processing_fee
    if @stripe
      amount = total_before_fees.fractional
      Money.new(
        ((amount + 30) / (1 - 0.029)).round - amount,
        'USD'
      )
    else
      Money.new(0, 'USD')
    end
  end

  def total_before_fees
    attribution.values.reduce(Money.new(0, 'USD')) do |total, item|
      total + item
    end
  end

  def total
    total_before_fees + processing_fee
  end

  def final_attribution(amount_paid)
    difference = amount_paid - total_before_fees
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
