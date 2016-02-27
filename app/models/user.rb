class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable,
         omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    users = where(provider: auth.provider, uid: auth.uid)
    if auth.info.email == Rails.application.secrets.email_address
      users.first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
    else
      users.first
    end
  end
end
