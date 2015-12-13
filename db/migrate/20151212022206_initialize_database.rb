class InitializeDatabase < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string  :title
      t.text    :description
      t.string  :image_url
      t.date    :starts_at
      t.date    :ends_at

      t.timestamps null: false
    end

    create_table :events do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string   :taught_by
      t.string   :title
      t.string   :type
      t.text     :description
      t.string   :image_url
      t.integer  :ticket_cost
      t.string   :ticket_currency
      t.integer  :max_attendees
      t.integer  :package_id
      t.integer  :location_id
      t.string   :sku

      t.timestamps null: false
    end

    add_index :events, :package_id
    add_index :events, :location_id
    add_index :events, :sku, unique: true
    add_index :events, :type

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

      t.timestamps null: false
    end

    create_table :attendees do |t|
      t.integer :member_id
      t.integer :event_id
      t.string  :payment_method
      t.integer :payment_amount
      t.string  :payment_currency
      t.string  :payment_url
      t.timestamp :paid_at
      t.boolean :attended

      t.timestamps null: false
    end

    add_index :attendees, :event_id
    add_index :attendees, :member_id

    create_table :members do |t|
      t.string :name
      t.string :email

      t.timestamps null: false
    end

    add_index :members, :email, unique: true
  end
end
