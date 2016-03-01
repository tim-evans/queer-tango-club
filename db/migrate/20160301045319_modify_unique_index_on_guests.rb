class ModifyUniqueIndexOnGuests < ActiveRecord::Migration
  def change
    remove_index :guests, column: [:teacher_id, :session_id], unique: true
    add_index :guests, [:teacher_id, :session_id, :role], unique: true
  end
end
