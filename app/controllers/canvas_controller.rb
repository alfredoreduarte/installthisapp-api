class CanvasController < ApplicationController
	include Modules::BaseController
	before_action :authenticate_user, except: [
		:auth, 
		:standalone_auth, 
		:messages_create,
		:entities, 
		:entries, 
		:settings
	]
	before_action :load_application, :except => [:auth, :standalone_auth]

	def entities_authenticated
		
	end

	def settings
		respond_to do |format|
			format.json { render json: @application.setting.conf["preferences"] }
		end
	end

	def images
		image_dict_assets = @application.application_assets.where(attachment_file_name: "images.json")
		if image_dict_assets.length > 0
			response = {
				images_url: image_dict_assets.last.asset_url,
				# images_url: '...',
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
				respond_to do |format|
					format.json { render json: response }
				end
			else
				raise ActiveRecord::RecordNotFound, "No Application found for checksum #{params[:checksum]}"
			end
		else
			raise ParamsVerificationFailed, 'checksum'
		end
	end

	def auth
		if params[:canvas_id]
			fb_application = FbApplication.find_by(canvas_id: params[:canvas_id])
			if fb_application
				fb_connection = FbGraph2::Auth.new(fb_application.app_id, fb_application.secret_key)
				fb_auth = fb_connection.from_signed_request(params[:signed_request])
				page_data = fb_auth.payload[:page]
				fb_page = FbPage.find_by(identifier: page_data['id'])
				application = fb_application.applications.installed.where(fb_page_id: fb_page.id).first
				if application	
					application.module
					response = {
						title: application.title,
						checksum: application.checksum,
						fb_application_id: application.fb_application.app_id,
						stylesheet_url: application.application_assets.where(attachment_file_name: "styles.css").last.asset_url,
						messages_url: application.application_assets.where(attachment_file_name: "messages.json").last.asset_url,
						images_url: application.application_assets.where(attachment_file_name: "images.json").last.asset_url,
					}
					respond_to do |format|
						format.json { render json: response }
					end
				else
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

	def load_application
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
