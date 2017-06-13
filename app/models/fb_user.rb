class FbUser < ApplicationRecord
	has_many :access_tokens
	has_many :applications, :through => :access_tokens	

	# =======================
	# New API stuff
	# =======================
	has_many :api_key, foreign_key: "fb_user_id", class_name: "FbUserApiKey"

	def self.auth(fb_application)
		begin
			return FbGraph2::Auth.new(fb_application.app_id, fb_application.secret_key)
		rescue HTTPClient::ConnectTimeoutError
 			return nil
 		end
	end

	def self.test_sign_in(application_id, fb_application_id, fb_application_secret_key, signed_request)
		# Get App by checksum
		auth = FbGraph2::Auth.new(fb_application_id, fb_application_secret_key)
		signed_request = auth.from_signed_request(signed_request).user.fetch
		if signed_request
			return self.identify(auth, signed_request, application_id)
		else
			return false
		end
	end

	def self.identify(auth, signed_request, application_id)

		# Extend access token lifetime
		auth.fb_exchange_token 	= signed_request.access_token
		access_token_string = auth.access_token!

		# Identify
		user_data = self.get_fb_profile(access_token_string)

		# Intentar traer el user by token_for_business
		logger.info('que trae?')
		logger.info(user_data.raw_attributes)
		token_for_business =  user_data.raw_attributes[:token_for_business]
		user = FbUser.find_by(token_for_business: token_for_business)
		if user.nil?
			user = FbUser.find_by(identifier: user_data.id)
			if user.nil?
				user = FbUser.find_or_initialize_by(token_for_business: token_for_business)
			else
				user.token_for_business = token_for_business
			end
			user.save
		end

		# Save user metadata
		# user.name = user_data.name
		# user.save!

		# Create or update access_token
		access_token = AccessToken.find_or_initialize_by(fb_user_id: user.id, application_id: application_id)
		access_token.token = access_token_string
		access_token.save!

		user.update_basic_information_from_facebook(user_data)

		user = access_token.fb_user

		return user
	end

	def self.get_fb_profile(access_token)
		user_data = FbGraph2::User.me(access_token).fetch(:fields => "name, first_name, middle_name, last_name, birthday, email, link, locale, gender, updated_time, age_range, token_for_business")
		return user_data
	end
	# =======================
	# !New API stuff
	# =======================
	
	def access_token(application_id)
		self.access_tokens
	end
	
	def update_basic_information_from_facebook(data)  
		self.name = data.name
		self.first_name = data.first_name
		self.last_name = data.last_name
		self.identifier = data.id
		self.email = data.email
		self.save    
	end
end
