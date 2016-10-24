module FrontendController
	def settings
		respond_to do |format|
			format.json { render json: $application.setting.conf["preferences"] }
		end
	end
	def entries
		# expires_in 5.minutes, public: true
		identifier = $application.fb_page.identifier
		results_likes = TopFansLike.likes_by_page(identifier, $application.setting.conf["preferences"]["ignored_user_identifiers"], 10)
		results_comments = TopFansComment.comments_by_page(identifier, $application.setting.conf["preferences"]["ignored_user_identifiers"], 10)
		response = {
			status: 'ok',
			likes: results_likes,
			comments: results_comments,
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end
	private
end