class InitializeDatabase < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string  :title
      t.text    :description
      t.string  :type
      t.date    :starts_at
      t.date    :ends_at
      t.attachment :cover_photo

      t.timestamps null: false
    end

    add_index :events, :type

    create_table :guests do |t|
      t.integer :teacher_id
      t.integer :session_id
      t.string  :role
      t.text    :description

      t.timestamps null: false
    end

    add_index :guests, [:teacher_id, :session_id], unique: true

    create_table :teachers do |t|
      t.string :name
      t.string :url
      t.text   :bio

      t.timestamps null: false
    end

    create_table :photos do |t|
      t.integer :teacher_id
      t.integer :event_id
      t.attachment :attachment

      t.timestamps null: false
    end

    add_index :photos, :teacher_id
    add_index :photos, :event_id

    create_table :sessions do |t|
      t.string   :title
      t.text     :description
      t.integer  :guest_id
      t.integer  :location_id
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer  :ticket_cost
      t.string   :ticket_currency
      t.integer  :max_attendees
      t.integer  :event_id
      t.string   :sku

      t.timestamps null: false
    end

    add_index :sessions, :event_id
    add_index :sessions, :location_id
    add_index :sessions, :sku, unique: true

    create_table :locations do |t|
      t.string   :name
      t.string   :url
      t.string   :address_line
      t.string   :extended_address
      t.string   :city
      t.string   :region_code
      t.string   :postal_code
      t.string   :image_url
      t.string   :latitude
      t.string   :longitude
      t.attachment :photo

      t.string   :category
      t.integer  :event_location_id
      t.boolean  :safe_space

      t.timestamps null: false
    end

    create_table :attendees do |t|
      t.integer :member_id
      t.integer :session_id
      t.string  :payment_method
      t.integer :payment_amount
      t.string  :payment_currency
      t.string  :payment_url
      t.timestamp :paid_at
      t.boolean :attended

      t.timestamps null: false
    end

    add_index :attendees, :session_id
    add_index :attendees, :member_id
    add_index :attendees, [:session_id, :member_id], unique: true

    create_table :members do |t|
      t.string :name
      t.string :email

      t.timestamps null: false
    end

    add_index :members, :email, unique: true
  end
end
