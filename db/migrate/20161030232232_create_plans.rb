class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :slug
      t.float :price
      t.integer :interval, default: 1

      t.timestamps
    end
  end
end
