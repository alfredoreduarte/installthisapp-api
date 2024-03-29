class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.string :title
      t.string :checksum
      t.string :application_type
      t.integer :status, default: 0
      t.integer :fb_users_count
      t.references :fb_application, foreign_key: true
      t.references :fb_page, foreign_key: true
      t.references :admin, foreign_key: true

      t.timestamps
    end
  end
end
