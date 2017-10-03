class CreateModuleFormEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :module_form_entries do |t|
      t.json :payload
      t.references :application, foreign_key: true
      t.references :fb_user, foreign_key: true
      t.timestamps
    end
  end
end
