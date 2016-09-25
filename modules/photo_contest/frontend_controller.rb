module FrontendController
	def viewmodel
		respond_to do |format|
			format.json { render "./photo_contest/views/viewmodel.json" }
		end
	end
	def upload
		photo = $application.photos.new(photo_params)
		photo.user_id = $user.id
		photo.save
		respond_to do |format|
			format.json { render json: photo.as_json }
		end
	end
	def vote
		vote = $application.votes.new(vote_params)
		vote.user_id = $user.id
		vote.save
		respond_to do |format|
			format.json { render json: vote.photo.as_json(
				include: [:votes, :user], methods: [:thumbnail_url, :asset_url] 
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