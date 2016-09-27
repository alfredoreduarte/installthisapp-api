class FbPage < ApplicationRecord
	has_and_belongs_to_many :admin_users
	has_many :applications
	validates_uniqueness_of  :identifier

	def self.save_basic_data(data)
		fb_page = FbPage.find_or_initialize_by(identifier: data.id)
		fb_page.name = data.name
		fb_page.fan_count = data.raw_attributes["country_page_likes"].nil? ? data.likes_count.to_i : data.raw_attributes["country_page_likes"].to_i
		fb_page.save
		return fb_page
	end

	def subscribe_to_realtime(admin_user,app = nil)
		require 'fb_graph2'
		require 'fb_api'
		if !self.webhook_subscribed
			begin
				f_page = FbGraph2::Page.new(self.identifier).fetch(:access_token => admin_user.access_token, :fields => :access_token)
				result = FbApi::subscribe_app(f_page.raw_attributes["access_token"], self.identifier)
				if result["success"] == true
					self.webhook_subscribed = true
					self.save
				else
					self.webhook_subscribed = false
					self.save
				end
			rescue Exception => e
				puts "ERROR al subscribir #{app.id} admin_user #{admin_user.id}"
				message = "We need to renew your permissions in order to update the scores table at Top Fans. Please uninstall your app and install it again."
				# AdminNotification.send_notification(admin_user,:error,I18n.t(message, :locale => app.admin_user.choosen_locale), "http://installthisapp.com/backend/applications/#{app.checksum}/dashboard")
			end
		end
	end

	def unsubscribe_to_realtime(admin_user)
		require 'fb_graph2'
		require 'fb_api'
		if self.webhook_subscribed
			begin
				f_page = FbGraph2::Page.new(self.identifier).fetch(:access_token => admin_user.access_token, :fields => :access_token)
				result = FbApi::unsubscribe_app(f_page.raw_attributes["access_token"], self.identifier)
				if result["success"] == true
					self.webhook_subscribed = false
					self.save
				end
			rescue Exception => e
				puts "ERROR al subscribir #{app.id} admin_user #{admin_user.id}"
				message = "We need to renew your permissions in order to update the scores table at Top Fans. Please uninstall your app and install it again."
				# AdminNotification.send_notification(admin_user,:error,I18n.t(message, :locale => app.admin_user.choosen_locale), "http://installthisapp.com/backend/applications/#{app.checksum}/dashboard")
			end
		end		
	end
end
