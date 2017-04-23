class Teacher < ActiveRecord::Base
  include PgSearch
  has_many :photos
  has_many :guests
  belongs_to :group

  pg_search_scope :search_for, against: :name, using: [:tsearch, :dmetaphone], ignoring: :accents

  accepts_nested_attributes_for :photos, reject_if: :all_blank

  def slug
    name.parameterize
  end
end
