class TopFansResetJob < ApplicationJob
	queue_as :default

	def perform(fb_page_identifier, access_token, start_date_as_i)
		TopFansLike.where(
			page_id: fb_page_identifier,
		).delete
		TopFansComment.where(
			page_id: fb_page_identifier,
		).delete
		Rails.logger.debug("Top Fans Reset Job with start_date #{start_date_as_i}")
		if start_date_as_i
			start_date = Time.at(start_date_as_i)
			user_graph = Koala::Facebook::API.new(access_token)
			page_token = user_graph.get_page_access_token(fb_page_identifier)
			koala = Koala::Facebook::API.new(page_token)
			feed = koala.get_connection('me', 'feed', since: start_date, limit: 10, fields: ['id', 'created_time'])
			loop do
				feed.each do |post|
					page_id = fb_page_identifier
					parent_id = post["id"]
					post_id = post["id"]
					comments = koala.get_connections(post["id"], "comments", limit: 20)
					if comments
						loop do
							comments.each do |comment|
								Rails.logger.info("Will save fb comment")
								value = {
									post_id: post_id,
									comment_id: comment["id"],
									message: comment["message"],
									parent_id: parent_id,
									sender_name: comment["from"]["name"],
									sender_id: comment["from"]["id"],
									verb: "add",
									item: "comment",
									created_time: comment["created_time"]
								}
								SaveFbCommentJob.perform_now(page_id, value)
							end
							comments = comments.next_page
							break unless comments != nil
						end
					end
					likes = koala.get_connections(post["id"], "likes", limit: 20, fields: ['name', 'created_time'])
					if likes
						loop do
							likes.each do |like|
								Rails.logger.info("Will save fb like")
								value = {
									parent_id: parent_id,
									sender_name: like["name"],
									sender_id: like["id"],
									post_id: post_id,
									verb: "add",
									item: "like",
									created_time: post["created_time"]
								}
								SaveFbLikeJob.perform_now(page_id, value)
							end
							likes = likes.next_page
							break unless likes != nil
						end
					end
				end
				feed = feed.next_page
				break unless feed != nil
			end
		end
	end
end
