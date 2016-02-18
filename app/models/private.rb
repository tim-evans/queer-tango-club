class Private < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :event
end
