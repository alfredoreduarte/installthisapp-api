module FrontendController

	def viewmodel
		@application = $application
		@photos = $application.photos.includes(:votes, :fb_user)
	end

	def upload
		@photo = $application.photos.new(photo_params)
		@photo.fb_user_id = $fb_user.id
		@photo.save
	end

	def vote
		logger.info('se puede subir?')
		logger.info($application.setting.conf["preferences"]["vote_many_times"])
		vote = $application.votes.new(vote_params)
		vote.fb_user_id = $fb_user.id
		vote.save
		@photo = vote.photo
	end

	private

	def photo_params
		params.require(:photo).permit(:caption, :attachment_url)
	end

	def vote_params
		params.require(:vote).permit(:photo_id)
	end

end