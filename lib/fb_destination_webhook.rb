module FbDestinationWebhook
	
	def self.fire!( admin, fb_lead, settings )
		Rails.logger.info("Will fire webhook")
		url = settings["url"]
		if url
			Rails.logger.info("Webhook has url #{url}")
			conn = Faraday::Connection.new url, {:ssl => {:verify => false}}
			res = conn.post do |req|
				# req.retry.max = 2
				# req.retry.interval = 0.05
				# req.retry.interval_randomness = 0.5
				# req.retry.backoff_factor = 2
				req.options.timeout = 30
				req.options.open_timeout = 10
				# Custom Payoload Type
				case settings["payload_type"]
					when 'json'
						elbody = self.process_body(fb_lead, settings)
						req.headers['Content-Type'] = 'application/json'
						req.body = "#{elbody.to_json}"
					when 'form'
						data = fb_lead.field_data
						query = data.map{ |datum| "#{datum["name"]}=#{datum["values"].join}"}
						string_to_encode = query.join('&')
						req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
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
			return true
		end
	end

	def self.process_body(fb_lead, settings)
		if !settings["fields_dictionary"].nil? && settings["fields_dictionary"].length > 0
			dictionary = settings["fields_dictionary"]
			data = fb_lead.field_data
			toreturn = dictionary.map{ |dict| { 
				"#{dict["key"]}" => data.find{|datum| datum["name"] == dict["value"]}["values"].length == 1 ? data.find{|datum| datum["name"] == dict["value"]}["values"].first : data.find{|datum| datum["name"] == dict["value"]}["values"] } 
			}
			toreturn = toreturn.reduce({}, :merge)
			return toreturn
		else
			return fb_lead.field_data
		end
	end

end