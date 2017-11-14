class CreateModuleCaptureTheFlagEntries < ActiveRecord::Migration[5.0]
	def change
		create_table :module_capture_the_flag_entries do |t|
			t.integer :elapsed_seconds
			t.references :application, foreign_key: true
			t.references :fb_user, foreign_key: true
			t.timestamps
		end
	end
end
