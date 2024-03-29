class CreateFbLeadDestinations < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_lead_destinations do |t|
      t.integer :destination_type
      t.integer :status, default: 0
      t.json :settings
      t.references :admin, foreign_key: true
      t.references :fb_leadform, foreign_key: true

      t.timestamps
    end
  end
end
