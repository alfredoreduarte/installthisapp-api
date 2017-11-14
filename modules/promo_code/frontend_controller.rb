module FrontendController

	def entities
		@success = true
	end

	def claim
		if @fb_user.nil?
			@success = false
			render
			return false
		end
		only_unique = @application.setting.conf["preferences"]["unique_codes_per_user"]
		claimed_codes_count = @application.entries.where(fb_user_id: @fb_user.id, code: params[:code]).count
		if !only_unique or claimed_codes_count == 0
			@entry = @application.entries.new(code: params[:code])
			if @entry
				@entry.fb_user_id = @fb_user.id
				@entry.save
				@entries_count = @application.entries.where(fb_user_id: @fb_user.id).count
				@success = true
			else
				@success = false
			end
		else
			@success = false
			# if claimed_vouchers_count > 0
			# 	@voucher = @application.vouchers.where(fb_user_id: @fb_user.id).order(updated_at: :desc).first
			# 	@success = !@voucher.nil?
			# else
			# 	@success = false
			# end
		end
	end
	
end