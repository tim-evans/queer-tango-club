class Photo < ActiveRecord::Base
  has_attached_file :attachment, styles: {
                      fill: '500x',
                      full_size: '600x800>',
                      thumb: 'x200'
                    }
  validates_attachment_content_type :attachment, content_type: %w(image/jpeg image/jpg image/png)
  belongs_to :event
  belongs_to :teacher

  def filename
    attachment.try(:original_filename)
  end

  def src(style=:fill)
    attachment.try(:url, style)
  end
end
