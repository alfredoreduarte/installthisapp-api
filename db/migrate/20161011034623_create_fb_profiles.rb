class CreateFbProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_profiles do |t|
      t.string :identifier
      t.string :access_token
      t.string :name
      t.string :first_name
      t.string :last_name
      t.references :admin, foreign_key: true

      t.timestamps
    end
  end
end
