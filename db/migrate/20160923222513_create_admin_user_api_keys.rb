class CreateAdminUserApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_user_api_keys do |t|
      t.string :token
      t.references :admin_user, foreign_key: true

      t.timestamps
    end
  end
end
