class Photo < ActiveRecord::Base
  has_attached_file :image, styles: { fill: 'x500' }
  belongs_to :event
end
