class SaveFbCommentJob < ApplicationJob
	queue_as :default

	def perform(page_id, values)
		Rails.logger.info('puto!')
		Rails.logger.info(values["sender_id"])
		TopFansComment.create(
			post_id: values["post_id"],
			comment_id: values["comment_id"],
			message: values["message"],
			parent_id: values["parent_id"],
			sender_name: values["sender_name"],
			created_time: values["created_time"],
			sender_id: values["sender_id"],
			page_id: page_id,
		)
	end
end
