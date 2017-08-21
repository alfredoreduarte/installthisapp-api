module FbDestinationWebhook
	
	def self.fire!( admin, fb_lead, settings )
		Rails.logger.info("Will fire webhook")
		url = settings["url"]
		if url
			Rails.logger.info("Webhook has url #{url}")
			conn = Faraday::Connection.new url, {:ssl => {:verify => false}}
			res = conn.post do |req|
				req.options.timeout = 10
				req.options.open_timeout = 5
				req.headers['Content-Type'] = 'application/json'
				req.headers['Accept'] = 'application/json'
				# custom headers
				settings["http_headers"].each do |header|
					req.headers[header["key"]] = header["value"]
				end
				req.body = "#{fb_lead.field_data.to_json}"
			end
			Rails.logger.info("Webhook sent to url #{url}")
		end
	end

end