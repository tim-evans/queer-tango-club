class GuestResource < BaseResource
  attributes :role, :credited
  has_one :teacher, always_include_linkage_data: true
  has_one :session, always_include_linkage_data: true
end

