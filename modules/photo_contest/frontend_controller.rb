module FrontendController

	def entities
		@application = @application
		@success = true
		@photos = @application.photos.includes(:votes, :fb_user)
	end

	def upload
		@photo = @application.photos.new(photo_params)
		@photo.fb_user_id = @fb_user.id
		@photo.save
	end

	def vote
		user_id = @fb_user.id
		multiple_votes_allowed = @application.setting.conf["preferences"]["multiple_votes_per_user"]
		photo_id = params[:vote][:photo_id]
		@photo = @application.photos.find(photo_id)
		if multiple_votes_allowed or @application.votes.where(fb_user_id: user_id).count == 0
			if @photo
				already_voted_for_this = @application.votes.where(fb_user_id: user_id, photo_id: photo_id).count > 0
				if !already_voted_for_this
					vote = @application.votes.new(vote_params)
					vote.fb_user_id = @fb_user.id
					vote.save
					@photo = vote.photo
				end
			end
		end
	end

	private

	def photo_params
		params.require(:photo).permit(:caption, :attachment_url)
	end

	def vote_params
		params.require(:vote).permit(:photo_id)
	end
	
end