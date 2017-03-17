class PhotoContestPhoto < ActiveRecord::Base
	self.table_name = "module_photo_contest_photos"
	belongs_to 	:application
	belongs_to 	:fb_user, class_name: "FbUser", foreign_key: :fb_user_id
	has_many 	:votes, class_name: "PhotoContestVote", foreign_key: :photo_id, dependent: :destroy
end
