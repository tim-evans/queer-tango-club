class SessionResource < BaseResource
  attributes :title, :description, :starts_at, :ends_at, :ticket_cost, :ticket_currency, :max_attendees, :level

  has_one :event, always_include_linkage_data: true
  has_one :location
  has_many :guests
end
