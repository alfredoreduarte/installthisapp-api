module FbDestinationEmail
	
	def self.fire!( admin, fb_lead, settings )
		recipients = settings["recipients"]
		if recipients
			# 
			# TODO: Create AdminNotifier
			# 
			AdminMailer.fb_lead_destination_email(recipients, admin, fb_lead).deliver	
			Rails.logger.info("Firing Fb lead destination: Email")
		end
	end

end