class User < ActiveRecord::Base
  include PgSearch

  devise :invalidatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :group

  pg_search_scope :search_for, against: %w(name email)

  def avatar_url
    avatar
  end

  def self.from_oauth(auth)
    user = where(provider: auth[:provider], uid: auth[:uid]).first
    if user.nil?
      user = find_by_email(auth[:email])
      # Instantiate the user for the first time
      if user
        user.provider = auth[:provider]
        user.uid = auth[:uid]
        user.name = auth[:name]
        user.email = auth[:email]
        user.avatar = auth[:image]
        user.password = Devise.friendly_token[0,20]
        user.save
      end
    end
    user
  end
end
