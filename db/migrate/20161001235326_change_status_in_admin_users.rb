class ChangeStatusInAdminUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :admin_users, :status
  	add_column :admin_users, :status, :integer, default: 0, after: :timezone
  	# remove_column :admin_users, :status
  	# change_column :admin_users, :status, 'integer USING CAST(status AS integer)', default: 0
  	# change_column :admin_users, :status, "integer USING NULLIF(status, '')::int", default: 0
  	# change_column :admin_users, :status, 'integer USING CAST(status AS integer)', default: 0
  end
end
