class Member < ActiveRecord::Base
  has_many :attendees
  has_many :sessions, through: :attendees
  after_create :subscribe_to_newsletter

  def formatted_email
    "\"#{name}\" <#{email}>" if email.present?
  end

  def subscribe_to_newsletter
    tinyletter = TinyletterService.new
    tinyletter.subscribe(email)
  end
end
