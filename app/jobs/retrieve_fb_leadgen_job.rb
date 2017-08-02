class RetrieveFbLeadgenJob < ApplicationJob
	queue_as :default

	def perform( leadgen_id, access_token )
		lead = FbApi::retrieve_leadgen( leadgen_id, access_token )
		FbLead.create(
			leadgen_id: lead["id"],
			created_time: lead["created_time"],
			field_data: lead["field_data"],
		)
		Rails.logger.info(lead)
	end
end
