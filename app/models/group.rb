class Group < ActiveRecord::Base
  has_many :events
  has_many :expenses
  has_many :locations
  has_many :members
  has_many :teachers
  has_many :transactions
  has_many :users
  has_many :sessions, through: :events

  belongs_to :logo, class_name: 'Photo'
  belongs_to :hero, class_name: 'Photo'

  before_create :generate_api_key

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex
    end while self.class.exists?(api_key: self.api_key)
  end
end
