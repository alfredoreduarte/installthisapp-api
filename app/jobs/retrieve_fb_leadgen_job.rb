class RetrieveFbLeadgenJob < ApplicationJob
	queue_as :default

	def perform( leadgen_id, access_token, fb_form_id )
		lead = FbApi::retrieve_leadgen( leadgen_id, access_token )
		FbLead.create(
			leadgen_id: lead["id"],
			created_time: lead["created_time"],
			field_data: lead["field_data"],
		)
		# Rails.logger.info(lead)
	end

	# 
	# Callback
	# 
	# TODO: al terminar de guardar el fb_leadgen, disparar las notificaciones a las integraciones
	# es decir, todo fb_lead_destination que pertenezca al fb_leadform
	# 
	after_perform do |job|
		fb_form_id = job.arguments.first[:form_id]
		# TODO: create FbLeadform
		fb_leadform = FbLeadform.find_by(fb_form_id: fb_form_id)
		fb_lead_destinations = fb_leadform.fb_lead_destinations.on # Get only destinations that are currently active
		fb_lead_destinations.each do |destination|
			destination.fire!
		end
	end

end
