class Teacher < ActiveRecord::Base
  has_attached_file :cover, styles: { jumbo: '400x' }
end
