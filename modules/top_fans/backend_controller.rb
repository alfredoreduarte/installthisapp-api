module BackendController

	def detail_by_user_and_page
		if !params[:sender_id].nil?
			# page_id = 
			integration = @application.app_integrations.fb_webhook_page_feed.first
			fb_page = nil
			if integration
				fb_page = FbPage.find_by(identifier: integration.settings["fb_page_identifier"])
			else
				# fb_page = FbPage.find_by(identifier: @application.app_integrations.fb_webhook_page_feed.first.settings["fb_page_identifier"])
				fb_page = @application.fb_page
			end
			likes = TopFansLike.detail_by_page_and_sender(fb_page.identifier, params[:sender_id])
			comments = TopFansComment.detail_by_page_and_sender(fb_page.identifier, params[:sender_id])
			render json: {
				status: "success",
				payload: {
					user: likes.as_json[0]["_id"],
					likes: likes.as_json[0]["likes"],
					comments: comments.as_json[0]["comments"],
				}
			}
		end
	end

	def subscribe_to_webhook
		if !params[:fb_page_identifier].nil? && @application.admin.can(:publish_apps)
			@application.install
			# get page
			fb_page = FbPage.find_by(identifier: params[:fb_page_identifier])
			# add integration 
			@application.app_integrations.create(integration_type: 1, settings: {
				fb_page_identifier: fb_page.identifier,
			})
			# subscribe page
			fb_page.subscribe_to_realtime(@application.admin, @application.fb_application)
			if @application.setting.conf["preferences"]["first_fetch_from_date"]
				TopFansLike.where(
					page_id: fb_page.identifier,
				).delete
				TopFansComment.where(
					page_id: fb_page.identifier,
				).delete
				start_date = @application.setting.conf["preferences"]["first_fetch_from_date"].to_datetime.to_i
				identifier = fb_page.identifier
				access_token = @application.admin.fb_profile.access_token
				TopFansResetJob.perform_later(identifier, access_token, start_date)
			else
				settings = @application.setting
				settings.conf["preferences"]["first_fetch_from_date"] = Time.now
				# settings.save
				@application.setting = settings
				@application.save
				# @application.setting.save
			end
			# 
			# Simulating admins#entities
			# TODO: corregir esto en el futuro
			# 
			@admin = current_admin
			@plans = SubscriptionPlan.all
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
		fb_page = nil
		if @application.app_integrations.fb_webhook_page_feed.first
			fb_page = FbPage.find_by(identifier: @application.app_integrations.fb_webhook_page_feed.first.settings["fb_page_identifier"])
		else
			fb_page = @application.fb_page
		end
		if fb_page
			fb_page.unsubscribe_to_realtime(@application.admin)
			# 
			# Remove starting date so that the next time user tries to install the tab there's no cached date
			# 
			# Sometimes people would re-install selecting "track only new interactions" 
			# but the app would instead fetch past posts because it had a previously saved starting date
			# 
			@application.setting.conf["preferences"]["first_fetch_from_date"] = nil
			@application.setting.save
			TopFansLike.where(
				page_id: fb_page.identifier,
			).delete
			TopFansComment.where(
				page_id: fb_page.identifier,
			).delete
			@application.app_integrations.fb_webhook_page_feed.destroy_all
		else
			logger.info('Tried to execute unsubscribe_from_webhook on an app with no fb_page')
		end
		@admin = current_admin
		render 'admins/entities'
	end

	def reset
		start_date = @application.setting.conf["preferences"]["first_fetch_from_date"].to_datetime.to_i
		fb_page = nil
		if @application.app_integrations.fb_webhook_page_feed.first
			fb_page = FbPage.find_by(identifier: @application.app_integrations.fb_webhook_page_feed.first.settings["fb_page_identifier"])
		else
			fb_page = @application.fb_page
		end
		identifier = fb_page.identifier
		access_token = @application.admin.fb_profile.access_token

		# 
		# Instead handling this asynchronously inside TopFansResetJob
		# 
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
		integration = @application.app_integrations.fb_webhook_page_feed.first
		fb_page = nil
		if integration
			fb_page = FbPage.find_by(identifier: integration.settings["fb_page_identifier"])
		else
			# fb_page = FbPage.find_by(identifier: @application.app_integrations.fb_webhook_page_feed.first.settings["fb_page_identifier"])
			fb_page = @application.fb_page
		end
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