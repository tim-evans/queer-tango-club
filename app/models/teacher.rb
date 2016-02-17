class Teacher < ActiveRecord::Base
  has_many :photos

  def slug
    name.parameterize
  end
end
