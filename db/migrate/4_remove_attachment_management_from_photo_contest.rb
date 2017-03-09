class RemoveAttachmentManagementFromPhotoContest < ActiveRecord::Migration[5.0]
	def change
		remove_column 	:module_photo_contest_photos, :attachment_file_name
		remove_column 	:module_photo_contest_photos, :attachment_content_type
		add_column 		:module_photo_contest_photos, :attachment_url, :string, limit: 255, after: :updated_at
	end
end
