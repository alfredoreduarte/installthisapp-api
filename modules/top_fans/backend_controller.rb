module BackendController
	def settings
		render json: @application.setting
	end

	def reset
		start_date = @application.setting.conf["preferences"]["first_fetch_from_date"].to_datetime.to_i
		identifier = @application.fb_page.identifier
		access_token = @application.admin.fb_profile.access_token
		TopFansLike.where(
			page_id: identifier,
		).delete
		TopFansComment.where(
			page_id: identifier,
		).delete
		TopFansResetJob.perform_later(identifier, access_token, start_date)
		render json: {
			status: "success",
			payload: {
				"#{identifier}": {
					likes: [],
					comments: [],
				}
			}
		}
	end

	def entries
		# remove this ONLY after dumping top fans in V2
		los_ids = FbPage.pluck(:identifier)
		TopFansCleanupJob.perform_later(los_ids)
		# 
		fb_page = @application.fb_page
		if fb_page
			identifier = fb_page.identifier
			ignored_identifiers = @application.setting.conf["preferences"]["ignored_user_identifiers"]
			results_likes = TopFansLike.likes_by_page(identifier, ignored_identifiers, 2500)
			results_comments = TopFansComment.comments_by_page(identifier, ignored_identifiers, 2500)
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
	def reset_scores_for_page
		identifier = @application.fb_page.identifier
		# TopFansCleanupJob.perform_later(identifier)
		@application.setting.conf["preferences"]["start_date"] = Time.now.utc
		@application.setting.save!
		render json: {
			status: "success",
			payload: {
				"#{identifier}": {
					likes: [],
					comments: [],
				}
			}
		}
	end
	private
end