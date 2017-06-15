class FbPage < ApplicationRecord
	has_and_belongs_to_many :fb_profiles
	has_many :applications
	validates_uniqueness_of  :identifier

	# def self.save_basic_data(data)
	# 	fb_page = FbPage.find_or_initialize_by(identifier: data.id)
	# 	fb_page.name = data.name
	# 	country_page_likes = data.raw_attributes["country_page_likes"]
	# 	fb_page.fan_count = country_page_likes.nil? ? data.likes_count.to_i : country_page_likes.to_i
	# 	logger.info("errorcito!")
	# 	logger.info(fb_page.errors)
	# 	fb_page.save
	# 	logger.info("errorcito dos!")
	# 	logger.info(fb_page.errors)
	# 	return fb_page
	# end

	def subscribe_to_realtime(admin_user,app = nil)
		require 'fb_graph2'
		require 'fb_api'
		if !self.webhook_subscribed
			logger.info('Fb Subscription request about to start')
			f_page = FbGraph2::Page.new(self.identifier).fetch(
				:access_token => admin_user.fb_profile.access_token, 
				:fields => :access_token
			)
			result = FbApi::subscribe_app(f_page.raw_attributes["access_token"], self.identifier)
			if result["success"] == true
				logger.info('Fb Subscription request success')
				self.webhook_subscribed = true
				self.save
			else
				logger.info('Fb Subscription request denied')
				self.webhook_subscribed = false
				self.save
			end
		end
	end

	def unsubscribe_to_realtime(admin_user)
		require 'fb_graph2'
		require 'fb_api'
		if self.webhook_subscribed
			begin
				f_page = FbGraph2::Page.new(self.identifier).fetch(
					:access_token => admin_user.access_token, 
					:fields => :access_token
				)
				result = FbApi::unsubscribe_app(f_page.raw_attributes["access_token"], self.identifier)
				if result["success"] == true
					self.webhook_subscribed = false
					self.save
				end
			rescue Exception => e
				puts "ERROR al des-subscribir #{self.id} admin_user #{admin_user.id}"
			end
		end		
	end
end
