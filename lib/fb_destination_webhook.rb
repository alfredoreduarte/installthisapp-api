module FbDestinationWebhook
	
	def self.fire!( admin, fb_lead, settings )
		url = settings["url"]
		if url
			conn = Faraday::Connection.new url, {:ssl => {:verify => false}}
			res = conn.post do |req|
				req.options.timeout = 10
				req.options.open_timeout = 5
				req.headers['Content-Type'] = 'application/json'
				req.headers['Accept'] = 'application/json'
				req.body = "#{fb_lead.field_data.to_json}"
			end
		end
	end

end