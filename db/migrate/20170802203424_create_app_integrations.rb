class CreateAppIntegrations < ActiveRecord::Migration[5.0]
  def change
    create_table :app_integrations do |t|
      t.references :application, foreign_key: true
      t.integer :integration_type
      t.json :settings

      t.timestamps
    end
  end
end
