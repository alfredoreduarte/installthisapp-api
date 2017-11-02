class FormEntry < ActiveRecord::Base
	self.table_name = "module_form_entries"
	belongs_to 	:application

	# before_save :enqueue_email

	attr_accessor :recipients

	def enqueue_email
		# payload = self.payload
		# logger.info('payload')
		# logger.info(self.payload)
		# logger.info(self.payload.class)
		# logger.info(JSON.parse(self.payload.to_s))
		# logger.info(self.payload.length)
		# logger.info(self.payload.length)
		# logger.info(JSON.parse(payload[0]))
		# logger.info(self.payload[0])
		# logger.info(self.payload.first)
		# if !self.recipients.nil?
		# 	admin_mail = ActionMailer::Base.mail(
		# 		from: "notifier@installthisapp.com", 
		# 		to: self.recipients,
		# 		subject: "InstallThisApp.com: Your Form #{self.application.title} received a new entry",
		# 		content_type: "text/html",
		# 		body: "<html><body>
		# 			<p><b>Product:</b> #{self.product.name}</p> \n
		# 			<p><b>Email:</b> #{self.email}</p> \n
		# 			<p><b>Phone:</b> #{self.phone}</p> \n
		# 			<p><b>Message:</b></p> \n
		# 			<p>#{self.content}</p> \n
		# 		</body></html>"
		# 	).deliver_later
		# end
	end
end
