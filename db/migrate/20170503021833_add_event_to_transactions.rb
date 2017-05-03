class AddEventToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :event_id, :integer

    add_index :transactions, :event_id
  end
end
