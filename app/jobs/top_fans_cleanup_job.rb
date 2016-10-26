class TopFansCleanupJob < ApplicationJob
	queue_as :default

	def perform(page_id)
		# Do something later
		TopFansLike.where(
			page_id: page_id,
		).delete
		TopFansComment.where(
			page_id: page_id,
		).delete
	end
end
