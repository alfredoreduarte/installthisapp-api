class FbLeadDestination < ApplicationRecord
	enum destination_type: { 
		email: 0, 
		mailchimp: 1,
		pipedrive: 2,
	}
	enum status: { 
		off: 0, 
		on: 1,
		deleted: 2
	}
	belongs_to		:admin
	belongs_to 		:fb_leadform

	before_create 	:generate_default_settings

	def fire!(fb_lead)
		require 'fb_destination_email'
		require 'fb_destination_mailchimp'
		settings = self.settings
		case self.destination_type.to_sym
			when :email
				FbDestinationEmail.fire!(self.admin, fb_lead, settings)
			when :mailchimp
				# TODO: add to mailchimp list
				FbDestinationMailchimp.fire!(settings)
			else
				# self.settings = {}
		end
	end
	
	private

		def generate_default_settings
			case self.destination_type.to_sym
				when :email
					self.settings = {
						recipients: "#{self.admin.email}"
					}
				when :mailchimp
					self.settings = {
						api_key: "",
						list_id: ""
					}
				else
					self.settings = {}
			end
		end
end
