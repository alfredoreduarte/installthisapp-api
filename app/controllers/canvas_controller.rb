class CanvasController < ApplicationController
	include Modules::BaseController
	before_action :authenticate_user, except: [
		:auth, 
		:standalone_auth, 
		:viewmodel, 
		:entries, 
		:settings
	]
	before_action :load_application, :except => [:auth, :standalone_auth]

	def standalone_auth
		application = Application.find_by(checksum: params[:checksum])
		response = {
			title: application.title,
			checksum: application.checksum,
			fb_application_id: application.fb_application.app_id,
			stylesheet_url: application.application_assets.where(attachment_file_name: "styles.css").last.asset_url,
			messages_url: application.application_assets.where(attachment_file_name: "messages.json").last.asset_url,
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def auth
		fb_application = FbApplication.find_by(canvas_id: params[:canvas_id])
		fb_connection = FbGraph2::Auth.new(fb_application.app_id, fb_application.secret_key)
		fb_auth = fb_connection.from_signed_request(params[:signed_request])
		page_data = fb_auth.payload[:page]
		fb_page = FbPage.find_by(identifier: page_data['id'])
		application = fb_application.applications.installed.where(fb_page_id: fb_page.id).first
		application.module
		response = {
			title: application.title,
			checksum: application.checksum,
			fb_application_id: application.fb_application.app_id,
			stylesheet_url: application.application_assets.where(attachment_file_name: "styles.css").last.asset_url,
			messages_url: application.application_assets.where(attachment_file_name: "messages.json").last.asset_url,
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def load_application
		$application = Application.find_by(checksum: params[:checksum])
		application_module = $application.module
		application_module.dispatch! self, :frontend, $application
	end

	private

	def authenticate_user
		authenticate_or_request_with_http_token do |token, options|
			api_key = UserApiKey.find_by(token: token)
			logger.info('el token')
			logger.info(api_key.token)
			$user = User.find(api_key.user_id)
			if $user
				return true
			else
				return false
			end
		end
	end
end
