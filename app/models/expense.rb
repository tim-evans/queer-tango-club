class Expense < ActiveRecord::Base
  belongs_to :event
  has_attached_file :receipt
  validates_presence_of :name, :amount
  validates_attachment_content_type :receipt, content_type: %w(image/jpeg image/jpg image/png)

  monetize :amount, as: :cost, with_model_currency: :currency, allow_nil: true

  def display_amount(format=:positive)
    if cost.try(:zero?)
      ''
    elsif format == :negative
      (cost * -1).try(:format, no_cents_if_whole: true)
    else
      cost.try(:format, no_cents_if_whole: true)
    end
  end

  def display_amount=(money)
    Monetize.assume_from_symbol = true
    amount = Monetize.parse(money)
    if amount.zero?
      self.cost = nil
    else
      self.cost = amount
    end
  end
end
