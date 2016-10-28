module FrontendController
	def settings
		respond_to do |format|
			format.json { render json: $application.setting.conf["preferences"] }
		end
	end
	def entries
		# expires_in 5.minutes, public: true
		limit_date = $application.setting.conf["preferences"]["start_date"] ? $application.setting.conf["preferences"]["start_date"].to_time : Time.now - 5.years
		identifier = $application.fb_page.identifier
		results_likes = TopFansLike.likes_by_page(identifier, $application.setting.conf["preferences"]["ignored_user_identifiers"], 10, limit_date)
		results_comments = TopFansComment.comments_by_page(identifier, $application.setting.conf["preferences"]["ignored_user_identifiers"], 10, limit_date)
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