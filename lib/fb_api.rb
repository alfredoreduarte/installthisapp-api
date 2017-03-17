module FbApi
	FACEBOOK_GRAPH_URL = ENV['FB_GRAPH_URL']

	def self.notifications(app_id,access_token)
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response_stats = conn.get %{/v#{ENV['FB_API_VERSION']}/#{app_id}/notifications?access_token=#{access_token}}
		return JSON::parse(response_stats.body)["data"]
	end

	def self.last_notification_id(app_id,access_token)
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response_stats = conn.get %{/v#{ENV['FB_API_VERSION']}/#{app_id}/notifications?access_token=#{access_token}}
		data = JSON::parse(response_stats.body)["data"]
		return data.first["id"]
	end

	def self.subscribe_app(access_token,fb_page_id)
		conn = Faraday.new(FACEBOOK_GRAPH_URL) do |faraday|
			faraday.request  :url_encoded
			faraday.response :logger
			faraday.adapter  Faraday.default_adapter
		end
		url = "/v#{ENV['FB_API_VERSION']}/#{fb_page_id}/subscribed_apps?access_token=#{access_token}"
		response = conn.post(url)
		data = JSON::parse(response.body)
		return data
	end

	def self.unsubscribe_app(access_token,fb_page_id)
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response_stats = conn.delete %{/v#{ENV['FB_API_VERSION']}/#{fb_page_id}/subscribed_apps?access_token=#{access_token}}
		puts %{/v#{ENV['FB_API_VERSION']}/#{fb_page_id}/subscribed_apps?access_token=#{access_token}}
		data = JSON::parse(response_stats.body)
		return data
	end


	def self.post_info(access_token,post_id)
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response_stats = conn.get %{/v#{ENV['FB_API_VERSION']}/#{post_id}?access_token=#{access_token}}
		data = JSON::parse(response_stats.body)
		return data
	end

end