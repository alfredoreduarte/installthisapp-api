class CreateFbPages < ActiveRecord::Migration[5.0]
  def change
    create_table :fb_pages do |t|
      t.string :name
      t.integer :like_count
      t.string :identifier

      t.timestamps
    end
  end
end
