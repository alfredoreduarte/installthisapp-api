class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.text :conf
      t.references :application, foreign_key: true

      t.timestamps
    end
  end
end
