class CreateUserApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :user_api_keys do |t|
      t.string :token
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
