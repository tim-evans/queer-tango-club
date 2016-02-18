class AddFlagForPrivates < ActiveRecord::Migration
  def change
    create_table :privates do |t|
      t.string  :title
      t.text    :description
      t.integer :teacher_id
      t.integer :event_id
      t.date    :starts_at
      t.date    :ends_at

      t.timestamps null: false
    end
  end
end
