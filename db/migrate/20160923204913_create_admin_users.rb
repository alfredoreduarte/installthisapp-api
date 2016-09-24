class CreateAdminUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      t.string :identifier, limit: 20
      t.string :access_token
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :locale
      t.string :utype
      t.integer :total_likes_count
      t.integer :timezone

      t.timestamps
    end
  end
end
