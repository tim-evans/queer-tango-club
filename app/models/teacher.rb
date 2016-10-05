class Teacher < ActiveRecord::Base
  has_many :photos

  accepts_nested_attributes_for :photos, reject_if: :all_blank

  def slug
    name.parameterize
  end
end
