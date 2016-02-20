class AddLevelToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :level, :string
  end
end
