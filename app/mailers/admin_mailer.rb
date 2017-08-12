class AdminMailer < ApplicationMailer
	default from: 'hello@installthisapp.com'
 
	def fb_lead_destination_email(recipients, admin, fb_lead)
		@name = admin.name || admin.email
		@content = fb_lead.field_data
		Rails.logger.info('@content')
		Rails.logger.info(@content)
		mail(to: recipients, subject: 'New lead received')
	end
end
