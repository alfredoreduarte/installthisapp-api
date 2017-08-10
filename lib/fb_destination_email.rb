module FbDestinationEmail
	
	def self.fire!( settings )
		recipients = settings["recipients"]
		if recipients
			# 
			# TODO: Create AdminNotifier
			# 
			# AdminNotifier.send_signup_email(recipients).deliver	
			Rails.logger.info("Firing Fb lead destination: Email")
		end
	end

end