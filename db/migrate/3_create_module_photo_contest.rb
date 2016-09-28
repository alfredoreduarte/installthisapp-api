class CreateModulePhotoContest < ActiveRecord::Migration[5.0]
	def up
		create_table "module_photo_contest_photos" do |t|
			t.integer  "application_id", 			limit: 4, 			null: false
			t.integer  "user_id", 					limit: 4, 			null: false
			t.text     "caption"
			t.integer  "votes_count", 				default: 0
			t.string   "attachment_file_name", 		limit: 255
			t.string   "attachment_content_type", 	limit: 255
			t.timestamps
		end
		create_table "module_photo_contest_votes" do |t|
			t.integer  "application_id", 	limit: 4, 					null: false
			t.integer  "user_id", 			limit: 4, 					null: false
			t.integer  "photo_id", 			limit: 4, 					null: false
			t.timestamps
		end
	end
	def down
		drop_table :module_photo_contest_photos
		drop_table :module_photo_contest_votes
	end
end
