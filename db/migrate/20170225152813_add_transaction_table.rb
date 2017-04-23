class AddTransactionTable < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.text     :description
      t.datetime :paid_at
      t.text     :paid_by
      t.integer  :group_id
      t.integer  :receipt_id
      t.integer  :amount
      t.integer  :iou
      t.string   :currency
      t.string   :method
      t.string   :url
      t.text     :notes

      t.timestamps null: false
    end

    add_index :transactions, :group_id

    add_column :expenses, :transaction_id, :integer
    add_column :attendees, :transaction_id, :integer
  end
end
