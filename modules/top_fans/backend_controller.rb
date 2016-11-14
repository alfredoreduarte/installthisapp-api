module BackendController
	def settings
		render json: @application.setting
	end
	def entries
		# test
		# page = FbGraph2::Page.new(@application.fb_page.identifier).fetch(access_token: @application.admin.fb_profile.access_token, fields: :access_token)
		# page = FbGraph2::Page.new(@application.fb_page.identifier).fetch(
			# :access_token => @application.admin.fb_profile.access_token, 
			# :fields => :access_token
		# )
		# fb_since = Date.today - 1.month
		# feed = page.feed(:since => fb_since, :fields => "actions, message, picture, icon, from, likes.summary(1), comments.summary(1)", :limit => 100)
		# 

		# Koala
		user_graph = Koala::Facebook::API.new(@application.admin.fb_profile.access_token)
		# graph_fb_p = self.graph_facebook_page(fb_page_identifier)
		page_token = user_graph.get_page_access_token(@application.fb_page.identifier)
		koala = Koala::Facebook::API.new(page_token)
		elfeed = koala.get_connection('me', 'feed')
		# primero = elfeed.second
		# post = elfeed.next_page.first
		post = elfeed.third
		# elfeed.each do |post|
			# logger.info post["story"]
			if post["comments"]
				logger.info "=== Comments ==="
				post["comments"]["data"].each do |comment|
					logger.info "#{comment["from"]["name"]}: #{comment["message"]}"
				end
			end
			if post["comments"].next_page
				logger.info "=== Comments ==="
				post["comments"].next_page["data"].each do |comment|
					logger.info "#{comment["from"]["name"]}: #{comment["message"]}"
				end
			end
			if post["likes"]
				logger.info "=== Likers ==="
				post["likes"]["data"].each do |like|
					logger.info like["name"]
				end
			end
		# end
		# logger.info "traigo"
		# logger.info primero["comments"]["data"].first["message"]
		# logger.info primero

		# remove this after dumping top fans in V2
		# los_ids = FbPage.pluck(:identifier)
		# TopFansCleanupJob.perform_later(los_ids)
		# 
		if @application.fb_page
			identifier = @application.fb_page.identifier
			limit_date = @application.setting.conf["preferences"]["start_date"] ? @application.setting.conf["preferences"]["start_date"].to_time : 0
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