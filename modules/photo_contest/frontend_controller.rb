module FrontendController
	def viewmodel
		@application = $application
		@photos = $application.photos.includes(:votes, :fb_user)
	end
	def upload
		photo = $application.photos.new(photo_params)
		photo.fb_user_id = $fb_user.id
		photo.save
		@photo = photo
		# respond_to do |format|
		# 	format.json { render json: photo.as_json }
		# end
	end
	def vote
		vote = $application.votes.new(vote_params)
		vote.fb_user_id = $fb_user.id
		vote.save
		respond_to do |format|
			format.json { render json: vote.photo.as_json(
				include: [:votes, :fb_user], methods: [:thumbnail_url, :asset_url] 
			) }
		end
	end

	private

	def photo_params
		params.require(:photo).permit(:caption, :attachment)
	end
	def vote_params
		params.require(:vote).permit(:photo_id)
	end
end