module FbDestinationMailchimp
	
	def self.fire!( admin, fb_lead, settings )
		api_key = settings["api_key"]
		list_id = settings["list_id"]
		email_address = nil
		fb_lead.field_data.each do |datum|
			if datum["name"] == "email"
				email_address = datum["values"].first
			end
		end
		if api_key && list_id
			gibbon = Gibbon::Request.new(api_key: api_key, debug: true)
			begin
				gibbon.lists(list_id).members.create(
					body: {
						email_address: email_address,
						status: "subscribed",
						# Todo: add merge fields
						# merge_fields: {
							# FNAME: "Bob", 
							# LNAME: "Smith"
						# }
					}
				)
				return true
			rescue Gibbon::MailChimpError => e
				puts "Houston, we have a problem: #{e.message} - #{e.raw_body}"
			end
			Rails.logger.info("Fired Fb lead destination: Mailchimp")
		end
	end

end