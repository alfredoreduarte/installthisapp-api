class FbWebhooksController < ApplicationController

	def verify_page_subscription
		identifier = params[:fb_page_identifier]
		if identifier
			# Find fb page
			fb_page = FbPage.find_by(identifier: identifier)
			if fb_page
				# Get page access token
				user_graph = Koala::Facebook::API.new(fb_page.fb_profiles.first.access_token)
				page_token = user_graph.get_page_access_token(identifier)
				# Request subscribed apps list
				conn = Faraday::Connection.new ENV['FB_GRAPH_URL'], {:ssl => {:verify => false}}
				response = conn.get %{/v#{ENV['FB_API_VERSION']}/#{identifier}/subscribed_apps?access_token=#{page_token}}
				response = JSON::parse(response.body)
				render json: response
			end
		end
	end

	def receive
		if params[:"hub.verify_token"]
			logger.info('===== Facebook Webhook Verification =====')
			logger.info("verify_token = #{params[:'hub.verify_token']}")
			render plain: params[:"hub.challenge"]
		else
			hash = params
			logger.info('===== Facebook Webhook received =====')
			logger.info(params.inspect)
			# Verify that it is a page
			if params["object"].to_s == "page"
				entries = hash[:entry]
				entries.each do |entry|
					page_id = entry[:id]
					fb_page = FbPage.find_by(identifier: page_id)
					if fb_page
						if fb_page.webhook_subscribed
							entry[:changes].each do |change|
								# 
								# Top Fans
								# 
								# Verify that it's a change at feed level, not updated information about the page or something else
								# 
								if change[:field] == "feed"
									value = change[:value]
									# Manage post likes and reactions
									if value[:item] == "like"
										if value[:verb] == "remove"
											remove_like(page_id, value)
										elsif value[:verb] == "add"
											add_like(page_id, value)
										end
									# Manage post comments and replies
									elsif value[:item] == "comment"
										if value[:verb] == "remove"
											remove_comment(page_id, value)
										elsif value[:verb] == "add"
											add_comment(page_id, value)
										end
									end
								end
								# 
								# Leadgen
								# 
								if change[:field] == "leadgen"
									value = change[:value]
									save_leadgen_webhook({
										ad_id: value[:ad_id],
										form_id: value[:form_id],
										leadgen_id: value[:leadgen_id],
										created_time: value[:created_time],
										page_id: value[:page_id],
										adgroup_id: value[:adgroup_id],
									})
								end
							end
						else
							logger.info("Receiving webhook updates for a page that is marked as not subscribed at our database, page_id: #{page_id}")
						end
					else
						logger.info("Receiving webhook updates for a page that is not in our database, page_id: #{page_id}")
					end
				end
			end
			render plain: 'ok'
		end
	end

	private

	def save_leadgen_webhook( values )
		SaveFbLeadgenWebhook.perform_later({
			ad_id: values[:ad_id],
			form_id: values[:form_id],
			leadgen_id: values[:leadgen_id],
			created_time: values[:created_time],
			page_id: values[:page_id],
			adgroup_id: values[:adgroup_id],
		})
	end

	def add_like( page_id, value )
		SaveFbLikeJob.perform_later(page_id, {
			parent_id: value[:parent_id],
			sender_name: value[:sender_name],
			sender_id: value[:sender_id],
			created_time: value[:created_time],
			post_id: value[:post_id]
		})
	end

	def remove_like( page_id, value )
		DestroyFbLikeJob.perform_later(page_id, {
			parent_id: value[:parent_id],
			sender_id: value[:sender_id],
			post_id: value[:post_id]
		})
	end

	def add_comment( page_id, value )
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

	def remove_comment( page_id, value )
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
