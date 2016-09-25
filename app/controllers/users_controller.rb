class UsersController < ApplicationController
	before_action :get_user, :only => [:profile, :profile_interests_tab, :profile_work_and_education_tab, :profile_checkins_tab, :profile_applications_installed]
	before_action :add_application_id_by_default , :only => [:application_users_list]

	def create
		application = Application.find_by(checksum: params[:checksum])
		fb_app_id = application.fb_application_id
		fb_application = FbApplication.find(fb_app_id)
		$user = User.test_sign_in(application, fb_application, params[:signed_request])
		unless $user.api_key.length > 0
			$user.api_key.create
		end
		render json: {
			id: $user.id,
			api_key: $user.api_key.last.token,
		}
	end
		
	private
	
	def get_user
		@access_tokens = AccessToken.where("user_id = #{params[:id]} and application_id in (#{$admin_user.application_ids.join(",")})").includes(:application).order("access_tokens.updated_on DESC")
		if @access_tokens.length > 0
			@user = @access_tokens[0].user
		else
			render :text => "Erroorrr"
		end
	end
end
