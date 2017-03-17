class CreateModuleMemoryMatch < ActiveRecord::Migration[5.0]
	def change
		create_table :module_memory_match_cards do |t|
			t.string :attachment_url
			t.references :application, foreign_key: true

			t.timestamps
		end
		create_table :module_memory_match_entries do |t|
			t.integer :time, default: 0
			t.integer :clicks, default: 0
			t.references :fb_user, foreign_key: true
			t.references :application, foreign_key: true

			t.timestamps
		end
	end
end
