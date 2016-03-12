class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.integer :event_id
      t.string :description
      t.datetime :valid_until
      t.integer :fractional
      t.string :currency
      t.json :active_when
      t.integer :distribute_among, array: true
    end
  end
end
