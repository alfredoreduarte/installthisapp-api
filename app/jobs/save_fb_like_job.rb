class SaveFbLikeJob < ApplicationJob
	queue_as :default

	def perform(page_id, values)
		# Do something later
		TopFansLike.create(
			parent_id: values[:parent_id],
			sender_name: values[:sender_name],
			sender_id: values[:sender_id],
			created_time: values[:created_time],
			post_id: values[:post_id],
			page_id: page_id,
		)
	end
end
