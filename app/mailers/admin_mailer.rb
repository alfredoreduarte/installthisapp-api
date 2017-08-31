class AdminMailer < ApplicationMailer
	default from: 'hello@installthisapp.com'
 
	def fb_lead_destination_email(recipients, admin, fb_lead)
		@name = admin.first_name || admin.email
		@content = fb_lead.field_data
		mail(to: recipients, bcc: 'alfredoreduarte@gmail.com', subject: 'New lead received')
	end
end
