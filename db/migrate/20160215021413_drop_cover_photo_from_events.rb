class DropCoverPhotoFromEvents < ActiveRecord::Migration
  def up
    remove_attachment :events, :cover_photo
  end

  def down
    add_attachment :events, :cover_photo
  end
end
