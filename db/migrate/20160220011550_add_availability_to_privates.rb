class AddAvailabilityToPrivates < ActiveRecord::Migration
  def change
    remove_column :privates, :starts_at, :date
    remove_column :privates, :ends_at, :date
    add_column :privates, :availability, :tsrange, array: true
  end
end
