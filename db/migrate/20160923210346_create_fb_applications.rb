class CreateFbApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_applications do |t|
      t.string :name
      t.string :app_id
      t.string :secret_key
      t.string :application_type
      t.string :canvas_id
      t.string :namespace

      t.timestamps
    end
  end
end
