class Guest < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :session

  accepts_nested_attributes_for :teacher, reject_if: :all_blank

  delegate :name, :url, :bio, :slug, to: :teacher
  has_many :photos, through: :teacher
end
