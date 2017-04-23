class DiscountResource < BaseResource
  attributes :description, :valid_until, :fractional, :currency, :active_when, :distribute_among

  has_one :event, always_include_linkage_data: true
end
