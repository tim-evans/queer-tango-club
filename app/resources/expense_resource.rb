class ExpenseResource < BaseResource
  has_one :event, always_include_linkage_data: true
  has_one :transaction, always_include_linkage_data: true
end
