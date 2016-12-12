module FrontendController
	def settings
		respond_to do |format|
			format.json { render json: $application.setting.conf["preferences"] }
		end
	end
	def entries
		fb_page = $application.fb_page
		if fb_page
			identifier = fb_page.identifier
			ignored_identifiers = $application.setting.conf["preferences"]["ignored_user_identifiers"]
			results_likes = TopFansLike.likes_by_page(identifier, ignored_identifiers, 2500)
			results_comments = TopFansComment.comments_by_page(identifier, ignored_identifiers, 2500)
		else
			results_likes = []
			results_comments = []
		end
		response = {
			success: true,
			likes: results_likes.first(10),
			comments: results_comments.first(10),
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end
	private
end