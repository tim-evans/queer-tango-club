class AddReimbursementsToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses,  :expensed_by,   :text

    create_table :reimbursements do |t|
      t.integer  :amount, null: false
      t.string   :currency, null: false
      t.datetime :reimbursed_at, null: false
      t.integer  :expense_id, null: false

      t.timestamps null: false
    end
  end
end
