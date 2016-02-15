require 'open-uri'

class AddCoverPhotos < ActiveRecord::Migration
  def up
    create_table :cover_photos do |t|
      t.string     :title
      t.text       :description
      t.attachment :attachment
      t.integer    :event_id

      t.timestamps null: false
    end

    Event.all.each do |event|
      event.cover_photos.create(
        attachment: open(event.cover_photo.url(:original)),
        title: event.title
      )
    end
  end

  def down
    drop_table :cover_photos
  end
end
