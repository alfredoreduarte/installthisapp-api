class AdminUser < ApplicationRecord
	has_many :applications, -> {where.not(status: :deleted)}
	has_and_belongs_to_many :fb_pages
	has_many :api_key, foreign_key: "admin_user_id", class_name: "AdminUserApiKey"

	# 1- Initialise Facebook App
	def self.fb_auth(redirect_uri = nil)
		begin
			return FbGraph2::Auth.new(ENV['FB_APP_ID'], ENV['FB_SECRET_KEY'])
		rescue HTTPClient::ConnectTimeoutError
 			return nil
 		end
	end

	def self.sign_in(signed_request)
		fb_auth = self.fb_auth
		signed_request = fb_auth.from_signed_request(signed_request).user.fetch
		if signed_request
			return self.identify(fb_auth, signed_request, 'en', false)
		else
			return false
		end
	end

	# 3- Get signed user metadata
	def self.identify(fb_auth, signed_request, lang=nil, create_trial=true)

		# Get existing admin user or initialise a new one
		admin_user = AdminUser.where(identifier: signed_request.identifier).first_or_initialize

		# Extend access token lifetime
		fb_auth.fb_exchange_token 	= signed_request.access_token
		admin_user.access_token = fb_auth.access_token!

		# Get FB Profile for Admin User
		profile = admin_user.get_fb_profile

		# Save Admin Metadata
		admin_user.name 		= profile.name
		admin_user.first_name 	= profile.first_name
		admin_user.last_name 	= profile.last_name
		admin_user.email 		= profile.email
		admin_user.locale 		= profile.locale
		admin_user.utype 		= :admin
		admin_user.timezone 	= profile.timezone rescue 0

		if admin_user.save

		else
			logger.info("/*/*/*/ ERRORS! #{admin_user.errors.inspect} /*/*/*/")
		end
		return admin_user
	end

	def get_fb_profile
		return FbGraph2::User.me(self.access_token).fetch
	end
end
