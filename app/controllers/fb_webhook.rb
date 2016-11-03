class FbWebhookController < ApplicationController

	def top_fans
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
		SaveFbLikeJob.perform_later(page_id, {
			parent_id: value[:parent_id],
			sender_name: value[:sender_name],
			sender_id: value[:sender_id],
			created_time: value[:created_time],
			post_id: value[:post_id]
		})
	end

	def remove_like(page_id, value)
		DestroyFbLikeJob.perform_later(page_id, {
			parent_id: value[:parent_id],
			sender_id: value[:sender_id],
			post_id: value[:post_id]
		})
	end

	def add_comment(page_id, value)
		SaveFbCommentJob.perform_later(page_id, {
			post_id: value[:post_id],
			comment_id: value[:comment_id],
			message: value[:message],
			parent_id: value[:parent_id],
			sender_name: value[:sender_name],
			created_time: value[:created_time],
			sender_id: value[:sender_id]
		})
	end

	def remove_comment(page_id, value)
		DestroyFbCommentJob.perform_later(page_id, {
			comment_id: value[:comment_id],
			parent_id: value[:parent_id],
			sender_id: value[:sender_id],
		})
	end

	# def subscription_params
		# params.require(:fb_page_subscription).permit(:entry)
		# params.require(:entry)
	# end
end
