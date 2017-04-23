class AddGroup < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :api_key, null: false
      t.text   :about
      t.string :hostname, null: false
      t.attachment :logo
      t.attachment :hero

      t.timestamps null: false
    end

    add_column :events,    :group_id, :integer
    add_column :expenses,  :group_id, :integer
    add_column :locations, :group_id, :integer
    add_column :members,   :group_id, :integer
    add_column :teachers,  :group_id, :integer
    add_column :users,     :group_id, :integer
  end
end
