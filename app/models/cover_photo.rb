class CoverPhoto < ActiveRecord::Base
  has_attached_file :attachment, styles: {
                      grayscale: { convert_options: '-colorspace Gray' }
                    }
  validates_attachment_content_type :attachment, content_type: %w(image/jpeg image/jpg image/png)

  belongs_to :event

  def full_title
    if title
      if title == event.title
        title
      else
        "#{event.title}&mdash; #{title}".html_safe
      end
    else
      event.title
    end
  end
end
