class CreateTwoCheckoutNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :two_checkout_notifications do |t|
      t.json :body

      t.timestamps
    end
  end
end
