module FbApi
	FACEBOOK_GRAPH_URL = ENV['FB_GRAPH_URL']

	def self.retrieve_leadgen( leadgen_id, access_token )
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response = conn.get %{/v#{ENV['FB_API_VERSION']}/#{leadgen_id}}, { :access_token => access_token }
		return JSON::parse(response.body)
	end

	def self.send_test_lead( form_id, access_token )
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response = conn.post %{/v#{ENV['FB_API_VERSION']}/#{form_id}/test_leads}, { :access_token => access_token }
		return JSON::parse(response.body)
	end

	def self.read_test_leads( form_id, access_token )
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response = conn.get %{/v#{ENV['FB_API_VERSION']}/#{form_id}/test_leads}, { :access_token => access_token }
		Rails.logger.info('el read')
		Rails.logger.info(response.body)
		return JSON::parse(response.body)
	end

	def self.delete_test_lead( lead_id, access_token )
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response = conn.delete %{/v#{ENV['FB_API_VERSION']}/#{lead_id}}, { :access_token => access_token }
		return JSON::parse(response.body)
	end

	def self.retrieve_fb_page_leadgen_forms( fb_page_identifier, access_token )
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response = conn.get %{/v#{ENV['FB_API_VERSION']}/#{fb_page_identifier}/leadgen_forms}, { :access_token => access_token }
		return JSON::parse(response.body)
	end

	def self.get_id_for_app( user_id, access_token )
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response = conn.get %{/v#{ENV['FB_API_VERSION']}/#{user_id}/ids_for_apps/?app=#{ENV['FB_APP_ID']}&access_token=#{access_token}}
		response = JSON::parse(response.body)
		unless response["data"].nil?
			unless response["data"].empty?
				return response["data"].first["id"]
			else
				return false
			end
		else
			return false
		end
	end

	def self.generate_app_access_token( app_id, app_secret )
		conn = Faraday::Connection.new FACEBOOK_GRAPH_URL, {:ssl => {:verify => false}}
		response = conn.get %{/v#{ENV['FB_API_VERSION']}/oauth/access_token?client_id=#{app_id}&client_secret=#{app_secret}&grant_type=client_credentials}
		return JSON::parse(response.body)["access_token"]
	end

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

	def self.subscribe_app( access_token, fb_page_id )
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