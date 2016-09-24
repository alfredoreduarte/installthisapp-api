class AddStatusToAdminUser < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_users, :status, :string, default: 'pending'
  end
end
