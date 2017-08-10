class FbLeadDestination < ApplicationRecord
	enum destination_type: { 
		email: 0, 
		mailchimp: 1,
		pipedrive: 1
	}
	belongs_to		:admin
	has_and_belongs_to_many :fb_leadforms

	before_create 	:generate_default_settings

	def fire!
		require 'fb_destination_email'
		require 'fb_destination_mailchimp'
		settings = self.settings
		case self.destination_type
		when 0
			# TODO: send mail
			FbDestinationEmail.fire!(settings)
		when 1
			# TODO: add to mailchimp list
			FbDestinationMailchimp.fire!(settings)
		else
			self.settings = {}
	end
	
	private

	def generate_default_settings
		case self.destination_type
		when 0
			self.settings = {
				destinataries: []
			}
		when 1
			self.settings = {
				api_key: "",
				list_id: ""
			}
		else
			self.settings = {}
	end
end
