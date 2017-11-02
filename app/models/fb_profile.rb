class FbProfile < ApplicationRecord
	belongs_to :admin
	has_and_belongs_to_many :fb_pages
	validates :access_token, presence: true
	attr_accessor :signed_request

	def sign_in(signed_request)

		# Initialize our own fb app
		fb_auth = FbGraph2::Auth.new(ENV['FB_APP_ID'], ENV['FB_SECRET_KEY'])

		# Valudate received signed request 
		authenticated_signed_request = fb_auth.from_signed_request(signed_request).user.fetch

		# Create long-term access token
		fb_auth.fb_exchange_token = authenticated_signed_request.access_token
		access_token = fb_auth.access_token!
		self.access_token = access_token

		# Get profile data from fb
		fetched_fb_profile = FbGraph2::User.me(self.access_token).fetch

		# Save metadata from fb
		self.identifier = authenticated_signed_request.identifier
		self.name = fetched_fb_profile.name
		self.first_name = fetched_fb_profile.first_name
		self.last_name 	= fetched_fb_profile.last_name

		return true

	end

	def fetch_fb_pages
		if self.access_token
			FbGraph2.debug!
			fetched_fb_profile = FbGraph2::User.me(self.access_token).fetch
			fan_pages = fetched_fb_profile.accounts({
				:fields => "id, name, likes, country_page_likes"
			})
			loop do
				processed = fan_pages
				processed = processed.collect{|p| p unless p.category=="Application"}.compact
				unless processed.nil?
					for fan_page in processed
						like_count = fan_page.raw_attributes["country_page_likes"].to_i rescue fan_page.likes_count.to_i
						self.fb_pages << FbPage.find_or_initialize_by(identifier: fan_page.id)
						fb_page = FbPage.find_by(identifier: fan_page.id)
						fb_page.name = fan_page.name
						fb_page.like_count = like_count
						fb_page.save
					end
					self.save
				end
				fan_pages = fan_pages.next
				break unless fan_pages.length > 0
			end
		end
	end
end
