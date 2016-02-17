class Guest < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :session

  delegate :name, :url, :bio, :slug, to: :teacher
  has_many :photos, through: :teacher
end
