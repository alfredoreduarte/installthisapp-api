class FbLeadDestination < ApplicationRecord
	enum destination_type: { 
		email: 0, 
		mailchimp: 1,
		pipedrive: 2,
		webhook: 3,
	}
	enum status: { 
		off: 0, 
		on: 1,
		deleted: 2
	}

	belongs_to		:admin
	belongs_to 		:fb_leadform

	validates :destination_type, :status, :settings, presence: true

	def fire!(fb_lead)
		require 'fb_destination_email'
		require 'fb_destination_mailchimp'
		require 'fb_destination_webhook'

		settings = self.settings
		success = false
		case self.destination_type.to_sym
			when :email
				success = FbDestinationEmail.fire!(self.admin, fb_lead, settings)
			when :mailchimp
				success = FbDestinationMailchimp.fire!(self.admin, fb_lead, settings)
			when :webhook
				success = FbDestinationWebhook.fire!(self.admin, fb_lead, settings)
			when :pipedrive
				# TODO: add to pipedrive list
			else
				# 
		end
		fb_lead_notification = FbLeadNotification.find_by(lead_id: fb_lead["lead_id"], fb_lead_destination_id: self.id)
		if fb_lead_notification
			fb_lead_notification.update(
				success: success,
				retries: fb_lead_notification.retries + 1
			)
		else
			fb_lead_notification = FbLeadNotification.create(
				lead_id: fb_lead["lead_id"],
				fb_lead_destination_id: self.id,
				success: success,
				retries: 0
			)
		end

		# Notifying ourselves to track usage
		AdminMailer.notify_ourselves_about_leadgen_usage(self.admin, fb_lead.as_json).deliver_later
	end
	
	private

		# def generate_default_settings
		# 	case self.destination_type.to_sym
		# 		when :email
		# 			self.settings = {
		# 				recipients: "#{self.admin.email}"
		# 			}
		# 		when :mailchimp
		# 			self.settings = {
		# 				api_key: "",
		# 				list_id: ""
		# 			}
		# 		else
		# 			self.settings = {}
		# 	end
		# end
end
