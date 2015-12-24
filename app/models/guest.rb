class Guest < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :session
end
