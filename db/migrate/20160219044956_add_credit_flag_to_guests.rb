class AddCreditFlagToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :credited, :boolean, default: true
  end
end
