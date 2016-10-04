class CoverPhoto < ActiveRecord::Base
  belongs_to :event

  has_attached_file :attachment

  validates_attachment_content_type :attachment, content_type: %w(image/jpeg image/jpg image/png)
  validates_presence_of :attachment

  before_save :nullify_blank_values
  def nullify_blank_values
    self.title = nil if title.blank?
  end

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
