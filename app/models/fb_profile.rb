class FbProfile < ApplicationRecord
	belongs_to :admin
	has_and_belongs_to_many :fb_pages
	attr_accessor :signed_request

	def sign_in

		# Initialize our own fb app
		fb_auth = FbGraph2::Auth.new(ENV['FB_APP_ID'], ENV['FB_SECRET_KEY'])

		logger.info(fb_auth.inspect)

		# Valudate received signed request 
		authenticated_signed_request = fb_auth.from_signed_request(self.signed_request).user.fetch

		# Create long-term access token
		fb_auth.fb_exchange_token = authenticated_signed_request.access_token
		self.access_token = fb_auth.access_token!

		# Get profile data from fb
		fetched_fb_profile = FbGraph2::User.me(self.access_token).fetch

		# Save metadata from fb
		self.identifier = authenticated_signed_request.identifier
		self.name = fetched_fb_profile.name
		self.first_name = fetched_fb_profile.first_name
		self.last_name 	= fetched_fb_profile.last_name

		logger.info("elspectito")
		logger.info(self.inspect)

		return true
	end

	def fetch_fb_pages
		# Get profile data from fb
		fetched_fb_profile = FbGraph2::User.me(self.access_token).fetch
		fan_pages = fetched_fb_profile.accounts({
			:fields => "id, name, likes, country_page_likes"
			}).collect{|p| p unless p.category=="Application"}.compact

		unless fan_pages.nil?
			for fan_page in fan_pages
				like_count = fan_page.raw_attributes["country_page_likes"].nil? ? fan_page.likes_count.to_i : fan_page.raw_attributes["country_page_likes"].to_i
				fb_page = self.fb_pages << FbPage.find_or_initialize_by(identifier: fan_page.id)
				fb_page.name = fan_page.name
				fb_page.like_count = like_count
				# logger.info("errorcito!")
				# logger.info(fb_page.errors.inspect)
				fb_page.save
				# logger.info("errorcito dos!")
				# logger.info(fb_page.errors.inspect)
			end
			self.save
		end
	end
end
