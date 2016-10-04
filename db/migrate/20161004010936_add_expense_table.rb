class AddExpenseTable < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string  :name
      t.text    :description
      t.date    :expensed_at
      t.integer :event_id
      t.attachment :receipt
      t.integer  :amount
      t.string   :currency

      t.timestamps null: false
    end

    add_index :expenses, :event_id
  end
end
