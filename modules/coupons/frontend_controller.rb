module FrontendController

	def voucher
		if @fb_user
			@voucher = @application.vouchers.where(fb_user_id: @fb_user.id).order(updated_at: :desc).first
		end
		@success = !@voucher.nil?
	end

	def vouchers_claim
		allows_multiple = @application.setting.conf["preferences"]["multiple_vouchers_per_user"]
		claimed_vouchers_count = @application.vouchers.where(fb_user_id: @fb_user.id).count
		if allows_multiple or claimed_vouchers_count == 0
			@voucher = @application.vouchers.find_by(fb_user_id: nil)
			if @voucher
				@voucher.fb_user_id = @fb_user.id
				@voucher.save
				@success = true
			else
				@success = false
			end
		else
			if claimed_vouchers_count > 0
				@voucher = @application.vouchers.where(fb_user_id: @fb_user.id).order(updated_at: :desc).first
				@success = !@voucher.nil?
			else
				@success = false
			end
		end
	end
	
end