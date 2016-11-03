class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.references :admin, foreign_key: true
      t.string :external_id

      t.timestamps
    end
  end
end
