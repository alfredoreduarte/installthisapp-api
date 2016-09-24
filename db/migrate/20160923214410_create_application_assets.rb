class CreateApplicationAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :application_assets do |t|
      t.string :type
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :application_id

      t.timestamps
    end
  end
end
