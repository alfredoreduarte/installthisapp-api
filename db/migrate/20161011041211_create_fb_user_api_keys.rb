class CreateFbUserApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_user_api_keys do |t|
      t.string :token
      t.references :fb_user, foreign_key: true

      t.timestamps
    end
  end
end
