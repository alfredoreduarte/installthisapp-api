class CreateApplicationAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :application_assets do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.references :application, foreign_key: true

      t.timestamps
    end
  end
end
