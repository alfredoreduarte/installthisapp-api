class AdminMailer < ApplicationMailer
	default from: 'hello@installthisapp.com'
 
	def fb_lead_destination_email(recipients, admin, fb_lead)
		@name = admin.first_name || admin.email
		@content = fb_lead.field_data
		mail(to: recipients, subject: 'New lead received')
	end

	def notify_ourselves_about_leadgen_usage(admin, fb_lead)
		@admin_id = admin.id
		@admin_name = admin.first_name || admin.email
		@admin_email = admin.email
		@content = fb_lead.field_data
		mail(to: 'alfredoreduarte@gmail.com, martin@installthisapp.com', subject: 'Lead sent!')
	end
end
