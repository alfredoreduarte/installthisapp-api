class RetrieveFbLead < ApplicationJob
	queue_as :default

	def perform( leadgen_id, access_token )
		raw_lead = FbApi::retrieve_leadgen( leadgen_id, access_token )
		fb_lead = FbLead.create(
			lead_id: raw_lead["id"],
			created_time: raw_lead["created_time"],
			ad_id: raw_lead["ad_id"],
			form_id: raw_lead["form_id"],
			field_data: raw_lead["field_data"],
		)
		# Fire integrations
		fb_leadform = FbLeadform.find_by(fb_form_id: lead["form_id"])
		fb_lead_destinations = fb_leadform.fb_lead_destinations.on # Get only destinations that are currently active
		fb_lead_destinations.each do |destination|
			destination.fire!(fb_lead)
		end
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
