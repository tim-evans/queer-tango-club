class Photo < ActiveRecord::Base
  has_attached_file :attachment, styles: { fill: '500x', fitted_height: 'x400' }
  validates_attachment_content_type :attachment, content_type: %w(image/jpeg image/jpg image/png)
  belongs_to :event
  belongs_to :teacher

  def filename
    attachment.try(:original_filename)
  end

  def src
    attachment.try(:url, :fill)
  end
end
