class UserResource < BaseResource
  attributes :email, :name, :avatar_url, :last_sign_in_at

  has_one :group

  before_create do
    @model.group = context[:group]
    @model.password = @model.password_confirmation = Devise.friendly_token[0,20]
  end

  def self.records(options={})
    options[:context][:group].users
  end

  def self.updatable_fields(context)
    super - [:avatar_url]
  end

  def self.creatable_fields(context)
    super - [:avatar_url]
  end
end
