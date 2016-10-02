class ChangeUtypeInAdminUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :admin_users, :utype
  	add_column :admin_users, :utype, :integer, default: 0, after: :timezone
  	# change_column :admin_users, :utype, 'integer USING CAST(utype AS integer)', default: 0
  	# change_column :admin_users, :utype, "integer USING NULLIF(utype, '')::int", default: 0
  	# change_column :admin_users, :utype, 'integer USING CAST(utype AS integer)', default: 0
  end
end
