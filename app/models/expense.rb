class Expense < ActiveRecord::Base
  include PgSearch

  belongs_to :event
  belongs_to :group
  belongs_to :payment, class_name: 'Transaction', foreign_key: :transaction_id

  has_attached_file :receipt, { preserve_files: true }

  pg_search_scope :search_for, against: %w(name expensed_by)

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
