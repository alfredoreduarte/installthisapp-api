class FbPageSubscriptionController < ApplicationController
	def top_fans_stats
		@results_likes = TopFansLike.detail_by_page
		@results_comments = TopFansComment.detail_by_page
	end

	def likes_by_page
		@results_likes = TopFansLike.likes_by_page(params[:identifier])
	end

	def subscription
		if params[:"hub.verify_token"]
			logger.info('===== Top Fans Real time Verification =====')
			logger.info("verify_token = #{params[:'hub.verify_token']}")
			render plain: params[:"hub.challenge"]
		else
			hash = params
			logger.info('===== Top Fans Real time entry received =====')
			logger.info(params.inspect)
			entries = hash[:entry]
			if params["object"].to_s == "page"
				entries.each do |entry|
					page_id = entry[:id]
					entry[:changes].each do |change|
						if change[:field] == "feed"
							value = change[:value]
							if value[:item] == "like"
								if value[:verb] == "remove"
									remove_like(page_id, value)
								elsif value[:verb] == "add"
									add_like(page_id, value)
								end
							elsif value[:item] == "comment"
								if value[:verb] == "remove"
									remove_comment(page_id, value)
								elsif value[:verb] == "add"
									add_comment(page_id, value)
								end
							end
						end
					end
				end
			end
			render plain: 'ok'
		end
	end

	private

	def add_like(page_id, value)
		TopFansLike.create(
			parent_id: value[:parent_id],
			sender_name: value[:sender_name],
			sender_id: value[:sender_id],
			created_time: value[:created_time],
			post_id: value[:post_id],
			page_id: page_id,
		)
	end

	def remove_like(page_id, value)
		TopFansLike.where(
			parent_id: value[:parent_id],
			sender_id: value[:sender_id],
			post_id: value[:post_id],
			page_id: page_id,
		).delete
	end

	def add_comment(page_id, value)
		TopFansComment.create(
			post_id: value[:post_id],
			comment_id: value[:comment_id],
			message: value[:message],
			parent_id: value[:parent_id],
			sender_name: value[:sender_name],
			created_time: value[:created_time],
			sender_id: value[:sender_id],
			page_id: page_id,
		)
	end

	def remove_comment(page_id, value)
		TopFansComment.where(
			comment_id: value[:comment_id],
			parent_id: value[:parent_id],
			sender_id: value[:sender_id],
		).delete
	end

	# def subscription_params
		# params.require(:fb_page_subscription).permit(:entry)
		# params.require(:entry)
	# end
end
