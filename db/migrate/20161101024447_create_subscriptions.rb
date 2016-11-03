class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :customer, foreign_key: true
      t.references :plan, foreign_key: true
      t.string :external_id
      t.date :active_until

      t.timestamps
    end
  end
end
