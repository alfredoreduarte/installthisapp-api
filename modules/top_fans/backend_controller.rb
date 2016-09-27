module BackendController
	def likes
		identifier = @application.fb_page.identifier
		results_likes = TopFansLike.likes_by_page(identifier)
		response = {
			"#{identifier}": results_likes
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end
	private
end