module FbDestinationMailchimp
	
	def self.fire!( settings )
		api_key = settings["api_key"]
		list_id = settings["list_id"]
		if api_key && list_id
			# 
			# TODO: Add Mailchimp code
			# 
			# AdminNotifier.send_signup_email(recipients).deliver	
			Rails.logger.info("Firing Fb lead destination: Mailchimp")
		end
	end

end