class InitializeDatabase < ActiveRecord::Migration
  def change
    create_table :package do |t|
      t.string :title
      t.text   :description
      t.string :image_url
      t.date   :starts_at
      t.date   :ends_at

      t.timestamps null: false
    end

    create_table :event do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string   :taught_by
      t.string   :title
      t.string   :type
      t.text     :description
      t.string   :image_url
      t.integer  :package_id
      t.string   :sku

      t.timestamps null: false
    end

    add_index :event, :package_id
    add_index :event, :sku
    add_index :event, :type

    create_table :attendee do |t|
      t.integer :member_id
      t.integer :event_id
      t.string  :payment_method
      t.string  :payment_url
      t.timestamp :paid_at
      t.boolean :attended

      t.timestamps null: false
    end

    add_index :attendee, :event_id
    add_index :attendee, :member_id

    create_table :members do |t|
      t.string :name
      t.string :email

      t.timestamps null: false
    end

    add_index :members, :email, unique: true
  end
end
