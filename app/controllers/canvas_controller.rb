class CanvasController < ApplicationController
	include Modules::BaseController
	before_action :authenticate_user, except: [
		:fb_tab_auth, 
		:standalone_auth, 
		:data_for_gateway,
		:messages_create, # catalog
		:entities, # most modules
		:entries, # most modules
		:settings # most modules
	]
	before_action :instantiate_application, :except => [:fb_tab_auth, :standalone_auth]

	def data_for_gateway
		fb_tab_app_identifier = nil
		if @application.app_integrations.fb_tab
			if @application.app_integrations.fb_tab.first
				fb_tab_app_identifier = @application.app_integrations.fb_tab.first.settings["fb_application_identifier"]
			end
		end
		fb_page = nil
		integration = @application.app_integrations.fb_webhook_page_feed.first
		if integration
			fb_page = FbPage.find_by(identifier: integration.settings["fb_page_identifier"])
		else
			fb_page = @application.fb_page
		end
		facebook_tab_url = !fb_tab_app_identifier.nil? ? "https://fb.com/#{fb_page.identifier}/app/#{fb_tab_app_identifier}" : nil
		render json: {
			has_fb_tab: !fb_tab_app_identifier.nil?,
			application_type: @application.application_type,
			title: @application.title,
			facebook_tab_url: facebook_tab_url
		}
	end

	def entities_authenticated
		
	end

	def settings
		render json: @application.setting.conf["preferences"]
	end

	def images
		image_dict_assets = @application.application_assets.where(attachment_file_name: "images.json")
		if image_dict_assets.length > 0
			response = {
				images_url: image_dict_assets.last.asset_url,
			}
		else
			response = {
				images_url: nil,
			}
		end
		render json: response
	end

	def standalone_auth
		if params[:checksum]
			application = Application.find_by(checksum: params[:checksum])
			if application
				image_dict_assets = application.application_assets.where(attachment_file_name: "images.json")
				response = {
					title: application.title,
					checksum: application.checksum,
					fb_application_id: application.fb_application.app_id,
					stylesheet_url: application.application_assets.where(attachment_file_name: "styles.css").last.asset_url,
					messages_url: application.application_assets.where(attachment_file_name: "messages.json").last.asset_url,
					images_url: image_dict_assets.length > 0 ? image_dict_assets.last.asset_url : nil,
				}
				render json: response
			else
				raise ActiveRecord::RecordNotFound, "No Application found for checksum #{params[:checksum]}"
			end
		else
			raise ParamsVerificationFailed, 'checksum'
		end
	end

	def fb_tab_auth
		if params[:canvas_id]
			fb_application = FbApplication.find_by(canvas_id: params[:canvas_id])
			if fb_application
				fb_connection = FbGraph2::Auth.new(fb_application.app_id, fb_application.secret_key)
				fb_auth = fb_connection.from_signed_request(params[:signed_request])
				page_data = fb_auth.payload[:page]
				fb_page = FbPage.find_by(identifier: page_data['id'])
				# 
				# TODO: Find another way to get application from the appintegrations. The fb_page_id column should be removed
				# from the applications table.
				# 
				logger.info('aca')
				application = fb_application.applications.installed.where(fb_page_id: fb_page.id).first
				if !application.nil?
					application.module
					response = {
						title: application.title,
						checksum: application.checksum,
						fb_application_id: application.fb_application.app_id,
						stylesheet_url: application.application_assets.where(attachment_file_name: "styles.css").last.asset_url,
						messages_url: application.application_assets.where(attachment_file_name: "messages.json").last.asset_url,
						images_url: application.application_assets.where(attachment_file_name: "images.json").last.asset_url,
					}
					render json: response
				else
					logger.error("Could not find an application associated to Facebook Page #{fb_page.identifier} and Facebook app")
					render json: {
						error: "Could not find an application associated to this Facebook Page and Facebook app"
					}
				end
			else
				raise ActiveRecord::RecordNotFound, "No fb_application found for canvas_id #{params[:canvas_id]}"
			end
		else
			raise ParamsVerificationFailed, 'canvas_id'
		end
	end

	def instantiate_application
		@application = Application.find_by(checksum: params[:checksum])
		application_module = @application.module
		application_module.dispatch!(self, :frontend, @application)
	end

	private

	def authenticate_user
		authenticate_or_request_with_http_token do |token, _options|
			api_key = FbUserApiKey.find_by(token: token)
			if api_key
				logger.info('el token')
				logger.info(api_key.token)
				@fb_user = FbUser.find(api_key.fb_user_id)
				if @fb_user
					return true
				else
					return false
				end
			else
				return false
			end
		end
	end
end
