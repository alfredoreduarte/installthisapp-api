module FbDestinationWebhook
	
	def self.fire!( admin, fb_lead, settings )
		url = settings["url"]
		if url
			# AdminMailer.fb_lead_destination_email(recipients, admin, fb_lead).deliver_now
			conn = url do |faraday|
				faraday.request  :url_encoded
				faraday.response :logger
				faraday.adapter  Faraday.default_adapter
			end
			# url = "/v#{ENV['FB_API_VERSION']}/#{fb_page_id}/subscribed_apps?access_token=#{access_token}"
			response = conn.post
			Rails.logger.info('sent post')
			Rails.logger.info(response.body)
			# data = JSON::parse(response.body)
			# return data
		end
	end

end