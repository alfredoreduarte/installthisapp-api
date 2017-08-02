module BackendController

	def subscribe_to_webhook
		if @application.fb_page && @application.admin.can(:publish_apps)
			@application.fb_page.subscribe_to_realtime(@application.admin, @application.fb_application)
			if @application.setting.conf["preferences"]["first_fetch_from_date"]
				TopFansLike.where(
					page_id: @application.fb_page.identifier,
				).delete
				TopFansComment.where(
					page_id: @application.fb_page.identifier,
				).delete
				start_date = @application.setting.conf["preferences"]["first_fetch_from_date"].to_datetime.to_i
				identifier = @application.fb_page.identifier
				access_token = @application.admin.fb_profile.access_token
				TopFansResetJob.perform_later(identifier, access_token, start_date)
			end
			render 'admins/entities'
		else
			render json: {
				success: false,
				message: "User can't publish apps"
			}
		end
	end

	def unsubscribe_from_webhook
		@application.uninstall
		if @application.fb_page
			@application.fb_page.unsubscribe_to_realtime(@application.admin)
			# 
			# Remove starting date so that the next time user tries to install the tab there's no cached date
			# 
			# Sometimes people would re-install selecting "track only new interactions" 
			# but the app would instead fetch past posts because it had a previously saved starting date
			# 
			@application.setting.conf["preferences"]["first_fetch_from_date"] = nil
			@application.setting.save
			TopFansLike.where(
				page_id: @application.fb_page.identifier,
			).delete
			TopFansComment.where(
				page_id: @application.fb_page.identifier,
			).delete
		else
			logger.info('Tried to execute unsubscribe_from_webhook on an app with no fb_page')
		end
		@admin = @application.admin
		render 'admins/entities'
	end

	def reset
		start_date = @application.setting.conf["preferences"]["first_fetch_from_date"].to_datetime.to_i
		identifier = @application.fb_page.identifier
		access_token = @application.admin.fb_profile.access_token

		# 
		# Instead handling this asynchronously inside TopFansResetJob
		# 
		# TopFansLike.where(
		# 	page_id: identifier,
		# ).delete
		# TopFansComment.where(
		# 	page_id: identifier,
		# ).delete

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
		fb_page = @application.fb_page
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		if fb_page
			identifier = fb_page.identifier
			ignored_identifiers = @application.setting.conf["preferences"]["ignored_user_identifiers"]
			ignored_identifiers = ignored_identifiers.length > 0 ? ignored_identifiers : []
			results_likes = TopFansLike.likes_by_page(identifier, ignored_identifiers, 2500)
			results_comments = TopFansComment.comments_by_page(identifier, ignored_identifiers, 2500)
			response = {
				application_log: @application_log,
				status: "success",
				payload: {
					"#{identifier}": {
						# likes: results_likes.first(50),
						likes: results_likes,
						# comments: results_comments.first(50),
						comments: results_comments,
					}
				}
			}
		else
			response = {
				application_log: @application_log,
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
	
end