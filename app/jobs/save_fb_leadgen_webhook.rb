class SaveFbLeadgenWebhook < ApplicationJob
	queue_as :default

	def perform( values )
		# Do something later
		FbLeadgenWebhook.create(
			ad_id: values[:ad_id],
			form_id: values[:form_id],
			leadgen_id: values[:leadgen_id],
			created_time: values[:created_time],
			page_id: values[:page_id],
			adgroup_id: values[:adgroup_id],
		)
	end
end
