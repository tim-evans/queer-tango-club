class OrderService

  attr_reader :sessions, :event

  def initialize(sessions, at: DateTime.now, stripe: false)
    @sessions = sessions.compact
    @event = @sessions.first.event
    @discounts = @event.discounts
    @ordered_at = at
    @stripe = stripe
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
