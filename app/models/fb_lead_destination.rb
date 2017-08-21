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
		case self.destination_type.to_sym
			when :email
				FbDestinationEmail.fire!(self.admin, fb_lead, settings)
			when :mailchimp
				# TODO: add to mailchimp list
				FbDestinationMailchimp.fire!(self.admin, fb_lead, settings)
			when :webhook
				FbDestinationWebhook.fire!(self.admin, fb_lead, settings)
			when :pipedrive
				# TODO: add to pipedrive list
			else
				# 
		end
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
