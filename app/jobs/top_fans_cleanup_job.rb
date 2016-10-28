class TopFansCleanupJob < ApplicationJob
	queue_as :default

	def perform(page_ids_array)
		# Do something later
		TopFansLike.where(
			# page_id: page_id,
			page_id: { '$nin': page_ids_array }
		).delete
		TopFansComment.where(
			# page_id: page_id,
			page_id: { '$nin': page_ids_array }
		).delete
	end
end
