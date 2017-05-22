class CatalogMessage < ActiveRecord::Base
	self.table_name = "module_catalog_messages"
	belongs_to 	:application
	belongs_to 	:product, :class_name => "CatalogProduct"#, counter_cache: :requests_count # should add requests_count column to products first
	before_save :enqueue_email

	attr_accessor :recipients

	def enqueue_email
		admin_mail = ActionMailer::Base.mail(
			from: "notifier@installthisapp.com", 
			to: self.recipients,
			subject: "Message from #{self.application.title} - Product: #{self.product.name}",
			content_type: "text/html",
			body: "<html><body>
				<p><b>Product:</b> #{self.product.name}</p> \n
				<p><b>Email:</b> #{self.email}</p> \n
				<p><b>Phone:</b> #{self.phone}</p> \n
				<p><b>Message:</b></p> \n
				<p>#{self.content}</p> \n
			</body></html>"
		).deliver_later

		customer_mail = ActionMailer::Base.mail(
			from: "notifier@installthisapp.com", 
			to: self.email,
			subject: "Your message has been received by #{self.application.title}",
			content_type: "text/html",
			body: "<html><body>
				<p>Hi! Your message regarding <i>#{self.product.name}</i> has been received by #{self.application.title} and will get a reply soon.</p> \n
			</body></html>"
		).deliver_later
	end
end
