class UsersController < ApplicationController
	before_action :add_application_id_by_default , :only => [:application_users_list]

	def create
		application = Application.find_by(checksum: params[:checksum])
		fb_app_id = application.fb_application_id
		fb_application = FbApplication.find(fb_app_id)
		@fb_user = User.test_sign_in(application, fb_application, params[:signed_request])
		unless @fb_user.api_key.length > 0
			@fb_user.api_key.create
		end
		render json: {
			id: @fb_user.id,
			api_key: @fb_user.api_key.last.token,
		}
	end
end
