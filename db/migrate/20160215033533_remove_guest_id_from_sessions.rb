class RemoveGuestIdFromSessions < ActiveRecord::Migration
  def change
    remove_column :sessions, :guest_id
  end
end
