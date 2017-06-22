module FrontendController
	
	def entries
		fb_page = @application.fb_page
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
			likes: results_likes,
			# comments: results_comments.first(50),
			comments: results_comments,
		}
		respond_to do |format|
			format.json { render json: response }
		end
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
		respond_to do |format|
			format.json { render json: response }
		end
	end
end