module FbDestinationEmail
	
	def self.fire!( admin, fb_lead, settings )
		recipients = settings["recipients"]
		if recipients
			AdminMailer.fb_lead_destination_email(recipients, admin, fb_lead).deliver_now
		end
	end

end