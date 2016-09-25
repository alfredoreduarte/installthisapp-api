module FrontendController
	def likes
		identifier = $application.facebook_page.identifier
		results_likes = TopFansLike.likes_by_page(identifier)
		response = {
			status: 'ok',
			likes: results_likes
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end
	private
end