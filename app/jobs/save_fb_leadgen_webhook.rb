class SaveFbLeadgenWebhook < ApplicationJob
	queue_as :default

	def perform( values )
		# Making sure both the page and fb_leadform exist
		fb_leadform = FbLeadform.find_by(fb_form_id: values["form_id"])
		if fb_leadform.nil?
			logger.warn("Receiving webhook updates for a FB Leadform that is not in our database, fb_leadform: #{fb_leadform}")
			# raising errors here is unnecessary
			# raise ActiveRecord::RecordNotFound, "No fb_leadform found with fb_form_id #{values["form_id"]}"
			return false
		end
		fb_page = FbPage.find_by(identifier: values["page_id"])
		if fb_page
			FbLeadgenWebhook.create(
				ad_id: values["ad_id"],
				form_id: values["form_id"],
				leadgen_id: values["leadgen_id"],
				created_time: values["created_time"],
				page_id: values["page_id"],
				adgroup_id: values["adgroup_id"],
			)
		end
	end

	# 
	# Callback
	# 
	after_perform do |job|
		# Making sure both the page and fb_leadform exist
		fb_leadform = FbLeadform.find_by(fb_form_id: job.arguments.first["form_id"])
		fb_page = FbPage.find_by(identifier: job.arguments.first["page_id"])

		if fb_leadform && fb_page
			fb_profile = fb_leadform.admin.fb_profile

			leadgen_id = job.arguments.first["leadgen_id"] # !!
			access_token = fb_profile.access_token # !!
			RetrieveFbLead.perform_later( leadgen_id, access_token, job.arguments.first["form_id"] )
		end
	end

end
