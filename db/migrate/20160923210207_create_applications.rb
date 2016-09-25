class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.string :title
      t.string :checksum
      t.string :application_type
      t.integer :status, default: 0
      t.integer :fb_application_id
      t.integer :admin_user_id
      t.integer :users_count, limit: 4, default: 0
      t.integer :fb_page_id
      t.integer :timezone
      t.datetime :first_time_installed_on

      t.timestamps
    end
  end
end
