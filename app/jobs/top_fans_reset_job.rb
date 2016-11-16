class TopFansResetJob < ApplicationJob
	queue_as :default

	def perform(fb_page_identifier, access_token, start_date_as_i)
		TopFansLike.where(
			page_id: fb_page_identifier,
		).delete
		TopFansComment.where(
			page_id: fb_page_identifier,
		).delete
		if start_date_as_i
			start_date = Time.at(start_date_as_i)
			user_graph = Koala::Facebook::API.new(access_token)
			page_token = user_graph.get_page_access_token(fb_page_identifier)
			koala = Koala::Facebook::API.new(page_token)
			elfeed = koala.get_connection('me', 'feed', since: start_date, limit: 10, fields: ['id', 'created_time'])
			begin
				elfeed.each do |post|
					page_id = fb_page_identifier
					parent_id = post["id"]
					post_id = post["id"]
					comments = koala.get_connections(post["id"], "comments", limit: 20)
					if comments
						begin
							comments.each do |comment|
								SaveFbCommentJob.perform_now(page_id, {
									post_id: post_id,
									comment_id: comment["id"],
									message: comment["message"],
									parent_id: parent_id,
									sender_name: comment["from"]["name"],
									created_time: comment["created_time"],
									sender_id: comment["from"]["id"]
								})
							end
							comments = comments.next_page
						end while comments != nil
					end
					likes = koala.get_connections(post["id"], "likes", limit: 20, fields: ['name', 'created_time'])
					if likes
						begin
							likes.each do |like|
								SaveFbLikeJob.perform_now(page_id, {
									parent_id: parent_id,
									sender_name: like["name"],
									sender_id: like["id"],
									post_id: post_id
								})
							end
							likes = likes.next_page
						end while likes != nil
					end
				end
				elfeed = elfeed.next_page
			end while elfeed != nil
		end
	end
end
