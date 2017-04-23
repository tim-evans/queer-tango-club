class MigratePhotos < ActiveRecord::Migration
  def change
    add_column :photos, :url, :string
    add_column :photos, :width, :integer
    add_column :photos, :height, :integer
    add_column :photos, :filename, :string
    add_column :photos, :filesize, :integer
    add_column :photos, :title, :string
    add_column :photos, :caption, :text

    # For groups
    add_column :groups, :logo_id, :integer
    add_column :groups, :hero_id, :integer

    # For locations
    add_column :locations, :photo_id, :integer

    # For expenses
    add_column :expenses, :receipt_id, :integer

    # Cover Photos
    add_column :cover_photos, :url, :string
    add_column :cover_photos, :width, :integer
    add_column :cover_photos, :height, :integer
    add_column :cover_photos, :filename, :string
    add_column :cover_photos, :filesize, :integer
  end
end
