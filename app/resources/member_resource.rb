class MemberResource < BaseResource
  attributes :name, :email

  has_one :group
  has_many :attendees

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    options[:context][:group].members
  end
end
