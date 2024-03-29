class DestroyFbCommentJob < ApplicationJob
	queue_as :default

	def perform(_page_id, values)
		TopFansComment.where(
			comment_id: values["comment_id"],
			parent_id: values["parent_id"],
			sender_id: values["sender_id"],
		).delete
	end
end
