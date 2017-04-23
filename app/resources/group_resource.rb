class GroupResource < BaseResource
  attributes :name, :about, :email, :hostname

  has_many :events
  has_many :expenses
  has_one :hero, class_name: 'photo', foreign_key_on: :self

  filter :api_key

  def self.records(options={})
    Group.where(id: options[:context][:group].id)
  end
end
