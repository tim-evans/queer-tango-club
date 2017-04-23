class AddCoverPhotoForeignKey < ActiveRecord::Migration
  def change
    add_column :photos, :tags, :text, array: true
  end
end
