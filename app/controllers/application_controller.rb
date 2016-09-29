class ApplicationController < ActionController::Base

	def get_application_for_admin(include_super_admin=true)
		checksum = params[:checksum] || params[:id]
		app = $admin_user.applications.find_by(checksum: checksum)
		return app
	end

	def add_application_id_by_default
		self.default_url_options = {
			:checksum => params[:checksum],
			:controller => :applications
		}
	end

	private

	def set_admin
		$admin_user = nil
		authenticate_or_request_with_http_token do |token, options|
			api_key = AdminUserApiKey.find_by(token: token)
			$admin_user = AdminUser.find(api_key.admin_user_id)
			if $admin_user
				return true
			else
				render json: {}, status: 401
			end
		end
	end

	def authenticate
		authenticate_or_request_with_http_token do |token, options|
			api_key = AdminUserApiKey.find_by(token: token)
		end
	end
end
