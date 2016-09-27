class FbPageSubscriptionController < ApplicationController
	def top_fans_stats
		@results_likes = TopFansLike.detail_by_page
		@results_comments = TopFansComment.detail_by_page
	end

	def likes_by_page
		@results_likes = TopFansLike.likes_by_page(params[:identifier])
	end

	def subscription
		hash = params
		logger.info('===== Top Fans Real time entry received =====')
		logger.info(params.inspect)
		entries = hash[:entry]
		entries.each do |entry|
			entry[:changes].each do |change|
				logger.info(change)
				if change[:field] == "feed"
					value = change[:value]
					item = value[:item]
					if item == "like"
						verb = value[:verb]
						page_id = value[:post_id].split("_")[0]
						post_id = value[:post_id].split("_")[1]
						user_identifier = value[:sender_id]
						user_name = value[:sender_name]
						if verb == "remove"
							TopFansLike.where(
								post_id: page_id,
								user_identifier: user_identifier,
								page_id: page_id,
							).delete
						elsif verb == "add"
							TopFansLike.create(
								post_id: post_id,
								user_identifier: user_identifier,
								user_name: user_name,
								page_id: page_id,
							)
						end
					elsif item == "comment"
						verb = value[:verb]
						page_id = value[:post_id].split("_")[0]
						post_id = value[:post_id].split("_")[1]
						comment_id = value[:comment_id].split("_")[1]
						user_identifier = value[:sender_id]
						user_name = value[:sender_name]
						if verb == "remove"
							TopFansComment.where(
								post_id: page_id,
								user_identifier: user_identifier,
								page_id: page_id,
								comment_id: comment_id,
							).delete
						elsif verb == "add"
							TopFansComment.create(
								post_id: post_id,
								user_identifier: user_identifier,
								user_name: user_name,
								page_id: page_id,
								comment_id: comment_id,
							)
						end
					end
				end
			end
		end
		if params[:"hub.challenge"]
			render plain: params[:"hub.challenge"]
		else
			render plain: 'ok'
		end
	end

	private

	# def subscription_params
		# params.require(:fb_page_subscription).permit(:entry)
		# params.require(:entry)
	# end
end
