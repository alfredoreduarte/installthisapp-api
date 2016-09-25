class PhotoContestVote < ActiveRecord::Base
	self.table_name = "module_photo_contest_votes"
	belongs_to 	:application
	belongs_to 	:user
	belongs_to 	:photo, :class_name => "PhotoContestPhoto", counter_cache: :votes_count

	# def user
	# 	self.attachment.url(:original)
	# end
end