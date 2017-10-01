class ProcessFbWebhookJob < ApplicationJob
	queue_as :urgent

	def perform(payload)
		entries = payload["entry"]
		entries.each do |entry|
			page_id = entry["id"]
			fb_page = FbPage.find_by(identifier: page_id)
			if fb_page.nil?
				logger.warn("Received webhook update for a page that is not in our database, page_id: #{page_id}")
				raise ActiveRecord::RecordNotFound, "No fb_page found with identifier #{page_id}"
				return false
			end
			if !fb_page.nil? && !fb_page.webhook_subscribed
				logger.warn("Received webhook update for a page that is not marked as subscribed at our database, page_id: #{page_id}")
				return false
			end
			entry["changes"].each do |change|
				value = change["value"]
				# 
				# Top Fans
				# 
				if change["field"] == "feed" # Verify that it's a change at feed level
					# Manage likes and reactions
					if value["item"] == "like"
						if value["verb"] == "remove"
							DestroyFbLikeJob.perform_later(page_id, value)
						elsif value["verb"] == "add"
							SaveFbLikeJob.perform_later(page_id, value)
						end
					# Manage comments and replies
					elsif value["item"] == "comment"
						if value["verb"] == "remove"
							DestroyFbCommentJob.perform_later(page_id, value)
						elsif value["verb"] == "add"
							SaveFbCommentJob.perform_later(page_id, value)
						end
					end
				end
				# 
				# Leadgen
				# 
				if change["field"] == "leadgen"
					SaveFbLeadgenWebhook.perform_later(value)
				end
			end
		end
	end
end
