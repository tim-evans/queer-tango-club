class GroupResource < BaseResource
  attributes :name, :about, :email, :hostname, :api_key

  has_many :events
  has_many :expenses
  has_one :hero, class_name: 'photo', foreign_key_on: :self

  filter :api_key

  def fetchable_fields
    if context[:current_user]
      super
    else
      super - [:api_key]
    end
  end

  def self.records(options={})
    Group.where(id: options[:context][:group].id)
  end
end
