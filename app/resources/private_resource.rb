class PrivateResource < BaseResource
  attributes :title, :description, :availability

  has_one :teacher
  has_one :event
end
