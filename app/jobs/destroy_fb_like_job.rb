class DestroyFbLikeJob < ApplicationJob
	queue_as :default

	def perform(page_id, values)
		# Do something later
		TopFansLike.where(
			parent_id: values[:parent_id],
			sender_id: values[:sender_id],
			post_id: values[:post_id],
			page_id: page_id,
		).delete
	end
end
