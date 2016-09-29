class CreateFbPages < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_pages do |t|
      t.string :name, limit: 255
      t.integer :fan_count, limit: 4, default: 0
      t.integer :identifier, limit: 8

      t.timestamps
    end
  end
end
