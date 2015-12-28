class Photo < ActiveRecord::Base
  has_attached_file :attachment, styles: { fill: 'x500' }
  validates_attachment_content_type :attachment, content_type: %w(image/jpeg image/jpg image/png)
  belongs_to :event
  belongs_to :teacher

  def src
    attachment.try(:url, :fill)
  end
end
