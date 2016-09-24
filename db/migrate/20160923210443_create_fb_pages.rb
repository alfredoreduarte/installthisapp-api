class CreateFbPages < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_pages do |t|
      t.string :name
      t.integer :fan_count
      t.integer :identifier

      t.timestamps
    end
  end
end
