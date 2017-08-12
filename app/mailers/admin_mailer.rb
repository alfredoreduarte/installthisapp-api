class AdminMailer < ApplicationMailer
	default from: 'hello@installthisapp.com'
 
	def fb_lead_destination_email(recipients, admin, fb_lead)
	# def fb_lead_destination_email
		# recipients = "alfredoreduarte@gmail.com"
		@name = admin.name || admin.email
		# @name = 'fdas'
		@form_id = fb_lead.form_id
		# @form_id = 123123
		@content = fb_lead.field_data
		# @content = 'contenido'
		# @content = [{
		#     "name": "car_make",
		#     "values": [
		#       "Honda"
		#     ]
		#   }, 
		#   {
		#     "name": "full_name", 
		#     "values": [
		#       "Joe Example"
		#     ]
		#   }, 
		#   {
		#     "name": "email", 
		#     "values": [
		#       "joe@example.com"
		#     ]
		#   }]
		# @url = 'http://example.com/login'
		mail(to: recipients, subject: 'New lead received')
	end
end
