module BackendController
	def settings
		render json: @application.setting
	end
	def entries
		# identifier = @application.fb_page.identifier
		identifier = @application.setting.conf["preferences"]["subscripted_fb_page_identifier"]
		if identifier.length > 1
			results_likes = TopFansLike.likes_by_page(identifier)
			results_comments = TopFansComment.comments_by_page(identifier)
			response = {
				status: "success",
				payload: {
					"#{identifier}": {
						likes: results_likes,
						comments: results_comments,
					}
				}
			}
		else
			response = {
				status: false,
			}
		end
		respond_to do |format|
			format.json { render json: response }
		end
	end
	def subscribe_real_time
		fb_page = FbPage.find_by(identifier: params[:fb_page_identifier])
		fb_page.subscribe_to_realtime(current_admin, @application.fb_application)
		setting = @application.setting
		setting.conf["preferences"]["subscripted_fb_page_identifier"] = params[:fb_page_identifier]
		render json: { status: 'success' }
	end
	private
end