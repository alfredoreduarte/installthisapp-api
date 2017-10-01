class FbWebhooksController < ApplicationController

	def verify_page_subscription
		identifier = params[:fb_page_identifier]
		if identifier
			# Find fb page
			fb_page = FbPage.find_by(identifier: identifier)
			if fb_page
				# Get page access token
				user_graph = Koala::Facebook::API.new(fb_page.fb_profiles.first.access_token)
				page_token = user_graph.get_page_access_token(identifier)
				# Request subscribed apps list
				conn = Faraday::Connection.new ENV['FB_GRAPH_URL'], {:ssl => {:verify => false}}
				response = conn.get %{/v#{ENV['FB_API_VERSION']}/#{identifier}/subscribed_apps?access_token=#{page_token}}
				response = JSON::parse(response.body)
				render json: response
			end
		end
	end

	def receive
		if params[:"hub.verify_token"]
			logger.info('===== Facebook Webhook Verification =====')
			render plain: params[:"hub.challenge"]
		else
			logger.info('===== Facebook Webhook Received =====')
			if params["object"].to_s == "page"
				ProcessFbWebhookJob.perform_later(params.as_json)
			end
			render plain: 'ok'
		end
	end

end
