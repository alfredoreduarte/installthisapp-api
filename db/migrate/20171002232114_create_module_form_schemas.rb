class CreateModuleFormSchemas < ActiveRecord::Migration[5.0]
  def change
    create_table :module_form_schemas do |t|
      t.json :structure, default: nil
      t.references :application, foreign_key: true
      t.timestamps
    end
  end
end
