module FrontendController

	def entities
		@entries = @application.entries.order(has_flag: :desc, elapsed_seconds: :desc).limit(10).includes(:fb_user)
		@time_left = (Time.parse(@application.setting.conf["preferences"]["end_time"]) - Time.now).to_i
		@success = true
	end

	# def entries
	# 	@entries = @application.entries.order("elapsed_seconds DESC").limit(10).includes(:fb_user)
	# 	@success = true
	# end

	def claim
		if @application.installed?
			old_token = @application.entries.where("has_flag = true").first
			if old_token.nil?
				token = @application.entries.find_or_create_by(fb_user_id: @fb_user.id)
				token.has_flag = true
				token.save
			else
				time_diff = old_token.elapsed_seconds.to_i + (Time.now - old_token.updated_at)
				old_token.elapsed_seconds = time_diff.to_i
				old_token.has_flag = false
				old_token.save
				token = @application.entries.find_or_create_by(fb_user_id: @fb_user.id)
				token.has_flag = true
				token.save
			end
			render json: {success: true}
		else
			render json: {success: false}
		end
	end
	
end