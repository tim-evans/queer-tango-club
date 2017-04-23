class AttendeeResource < BaseResource
  attribute :attended

  has_one :member, always_include_linkage_data: true
  has_one :session, always_include_linkage_data: true
  has_one :transaction, always_include_linkage_data: true
end
