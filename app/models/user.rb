class User < ApplicationRecord
	has_many :access_tokens
	has_many :applications, :through => :access_tokens	

	# =======================
	# New API stuff
	# =======================
	has_many :api_key, foreign_key: "user_id", class_name: "UserApiKey"

	def self.auth(fb_application)
		begin
			# return FbGraph2::Auth.new(Application::fb_app_data[:app_id], Application::fb_app_data[:client_secret])
			return FbGraph2::Auth.new(fb_application.app_id, fb_application.secret_key)
		rescue HTTPClient::ConnectTimeoutError
 			return nil
 		end
	end

	def self.test_sign_in(application, fb_application, signed_request)
		# Get App by checksum
		auth = User.auth(fb_application)
		signed_request = auth.from_signed_request(signed_request).user.fetch
		if signed_request
			return self.identify(auth, signed_request, application)
		else
			return false
		end
	end

	def self.identify(auth, signed_request, application)
		# Get existing admin user or initialise a new one
		# user = User.where(identifier: signed_request.identifier).first_or_initialize

		# Extend access token lifetime
		auth.fb_exchange_token 	= signed_request.access_token
		access_token_string = auth.access_token!

		# Identify
		user_data = self.get_fb_profile(access_token_string)

		# Intentar traer el user by token_for_business
		token_for_business =  user_data.raw_attributes[:token_for_business]
		user = User.find_by(token_for_business: token_for_business)
		if user.nil?
			user = User.find_by(identifier: user_data.id)
			if user.nil?
				user = User.find_or_initialize_by(token_for_business: token_for_business)
			else
				user.token_for_business = token_for_business
			end
			user.save
		end

		# Save user metadata
		# user.name = user_data.name
		# user.save!

		# Create or save access_token
		# access_token = AccessToken.where(application_id: signed_request.identifier).first_or_initialize
		access_token = AccessToken.find_or_initialize_by(user_id: user.id, application_id: application.id)
		# access_token = AccessToken.new(
		# 	application_id: application.id, 
		# 	user_id: user.id, 
		# 	token: access_token_string, 
		# 	user_identifier: user.identifier
		# )
		access_token.token = access_token_string
		access_token.save!

		user.update_basic_information_from_facebook(user_data)

		user = access_token.user

		return user

		# user.access_token = auth.access_token!
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
