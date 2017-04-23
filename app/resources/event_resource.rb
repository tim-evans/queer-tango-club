class EventResource < BaseResource
  attributes :title, :description, :starts_at, :ends_at, :published

  has_many :sessions, always_include_linkage_data: true
  has_many :discounts, always_include_linkage_data: true
  has_many :photos, always_include_linkage_data: true

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    context = options[:context]
    events = context[:group].events
    if context[:current_user]
      events
    else
      events.published
    end
  end
end
