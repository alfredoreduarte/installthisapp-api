# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
	
	def fb_lead_destination_email
		fb_lead_destination = FbLeadDestination.first

		recipients = fb_lead_destination.settings["recipients"]
		admin = fb_lead_destination.admin
		fb_lead = FbLead.first
		
		AdminMailer.fb_lead_destination_email(recipients, admin, fb_lead)
	end

end
