class Guest < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :session

  delegate :name, :url, :bio, to: :teacher
end
