class Private < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :event

  def contact
    Rails.application.secrets.email_address
  end
end
