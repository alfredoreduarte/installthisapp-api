module FrontendController

	def entries
		fb_page = get_fb_page
		if fb_page
			identifier = fb_page.identifier
			ignored_identifiers = @application.setting.conf["preferences"]["ignored_user_identifiers"]
			ignored_identifiers = ignored_identifiers.length > 0 ? ignored_identifiers : []
			results_likes = TopFansLike.likes_by_page(identifier, ignored_identifiers, 2500)
			results_comments = TopFansComment.comments_by_page(identifier, ignored_identifiers, 2500)
		else
			results_likes = []
			results_comments = []
		end
		response = {
			success: true,
			# likes: results_likes.first(50),
			likes: results_likes, # Stopped sending a subset because it was distorting frontend-calculated results
			# comments: results_comments.first(50),
			comments: results_comments, # Stopped sending a subset because it was distorting frontend-calculated results
		}
		expires_in 5.minutes, public: true
		render json: response
	end

	def single_user_scores
		require 'fb_api'
		if @fb_user
			fb_page = @application.fb_page
			if fb_page
				identifier = fb_page.identifier
				fb_app = @application.fb_application
				token = FbApi::generate_app_access_token(fb_app.app_id, fb_app.secret_key)
				user_identifier = FbApi::get_id_for_app(@fb_user.identifier, token)
				if user_identifier
					results_likes = TopFansLike.detail_by_page_and_user(identifier, user_identifier)
					results_comments = TopFansComment.detail_by_page_and_user(identifier, user_identifier)
				else
					results_likes = []
					results_comments = []
				end
			else
				results_likes = []
				results_comments = []
			end
			response = {
				success: true,
				identifier: @fb_user.identifier,
				name: @fb_user.name,
				likes: results_likes,
				comments: results_comments,
			}
		else
			response = {
				success: false,
			}
		end
		expires_in 5.minutes, public: true
		render json: response
	end

	def get_fb_page
		_fb_page = nil
		if @application.app_integrations.fb_webhook_page_feed
			if @application.app_integrations.fb_webhook_page_feed.first
				if @application.app_integrations.fb_webhook_page_feed.first.settings["fb_page_identifier"]
					_fb_page = FbPage.find_by(identifier: "#{@application.app_integrations.fb_webhook_page_feed.first.settings["fb_page_identifier"]}")
				end
			end
		end
		if _fb_page == nil
			logger.warn("Top Fans: Had to resort to application.fb_page at get_associated_fb_page")
			_fb_page = @application.fb_page
		end
		return _fb_page
	end
end