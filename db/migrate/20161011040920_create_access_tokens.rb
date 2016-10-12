class CreateAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens do |t|
      t.string :token
      t.references :fb_user, foreign_key: true
      t.references :application, foreign_key: true
      t.string :checksum
      t.string :identifier

      t.timestamps
    end
  end
end
