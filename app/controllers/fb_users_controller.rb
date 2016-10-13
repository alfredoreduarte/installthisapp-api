class FbUsersController < ApplicationController

	def create
		application = Application.find_by(checksum: params[:checksum])
		fb_app_id = application.fb_application_id
		fb_application = FbApplication.find(fb_app_id)
		$fb_user = FbUser.test_sign_in(application, fb_application, params[:signed_request])
		unless $fb_user.api_key.length > 0
			$fb_user.api_key.create
		end
		render json: {
			id: $fb_user.id,
			api_key: $fb_user.api_key.last.token,
		}
	end
		
	# private
	
	# def get_user
	# 	@access_tokens = AccessToken.where("fb_user_id = #{params[:id]} and application_id in (#{$admin_user.application_ids.join(",")})").includes(:application).order("access_tokens.updated_at DESC")
	# 	if @access_tokens.length > 0
	# 		@user = @access_tokens[0].user
	# 	else
	# 		render :text => "Erroorrr"
	# 	end
	# end
end
