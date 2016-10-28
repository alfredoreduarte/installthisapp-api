module BackendController
	def settings
		render json: @application.setting
	end
	def entries
		# los_ids = FbPage.pluck(:identifier)
		# los_ids = FbPage.pluck(:identifier)
		# logger.info('los ids')
		# logger.info(los_ids)
		# custom_ids = ["272699880986", "1489449298018747"]
		# TopFansCleanupJob.perform_later(custom_ids)
		identifier = @application.fb_page.identifier
		if identifier.length > 1

			limit_date = @application.setting.conf["preferences"]["start_date"] ? @application.setting.conf["preferences"]["start_date"].to_time : Time.now - 5.years
			ignored_identifiers = @application.setting.conf["preferences"]["ignored_user_identifiers"]

			results_likes = TopFansLike.likes_by_page(identifier, ignored_identifiers, 100, limit_date)
			results_comments = TopFansComment.comments_by_page(identifier, ignored_identifiers, 100, limit_date)

			results_likes.each do |like|
				logger.info('un like')
				logger.info(like.inspect)
			end
			results_comments.each do |comment|
				logger.info('un comment')
				logger.info(comment.inspect)
			end
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