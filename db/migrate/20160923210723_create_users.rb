class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :identifier
      t.string :email
      t.string :token_for_business

      t.timestamps
    end
  end
end
