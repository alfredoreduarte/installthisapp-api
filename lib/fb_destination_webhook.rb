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
				# Custom Payoload Type
				case settings["payload_type"]
					when 'json'
						req.headers['Content-Type'] = 'application/json'
						req.body = "#{fb_lead.field_data.to_json}"
					when 'form'
						req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
						data = fb_lead.field_data
						query = data.map{ |datum| "#{datum["name"]}=#{datum["values"].join}"}
						string_to_encode = query.join('&')
						req.body = URI.encode(string_to_encode)
					when 'xml'
						req.headers['Content-Type'] = 'application/xml; charset=utf-8'
						data = fb_lead.field_data
						query = data.map{ |datum| "<#{datum["name"]}>#{datum["values"].join}</#{datum["name"]}>"}
						req.body = query.join
					when 'raw'
						# req.body = "#{fb_lead.field_data.to_json}"
					else
						req.headers['Content-Type'] = 'application/json'
				end
				# Custom Headers
				if settings["http_headers"]
					settings["http_headers"].each do |header|
						req.headers[header["key"]] = header["value"]
					end
				end
			end
			Rails.logger.info("Webhook sent to url #{url}")
		end
	end

end