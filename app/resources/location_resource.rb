class LocationResource < BaseResource
  attributes :name, :url, :address_line, :extended_address,
             :city, :region_code, :postal_code, :safe_space,
             :latitude, :longitude, :slug

  has_one :photo, always_include_linkage_data: true

  filter :address_line, :city, :region_code

  before_create do
    @model.group = context[:group]
  end

  def self.updatable_fields(context)
    super - [:latitude, :longitude, :slug]
  end

  def self.creatable_fields(context)
    super - [:latitude, :longitude, :slug]
  end
end
