class Member < ActiveRecord::Base
  include PgSearch
  has_many :attendees
  has_many :sessions, through: :attendees
  belongs_to :group
  after_create :subscribe_to_newsletter

  pg_search_scope :search_for, against: %w(name email)

  def formatted_email
    "\"#{name}\" <#{email}>" if email.present?
  end

  def subscribe_to_newsletter
    tinyletter = TinyletterService.new
    tinyletter.subscribe(email)
  end
end
