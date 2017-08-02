class FbUsersController < ApplicationController
	before_action :get_application, :only => [ :create ]

	def create
		if params[:signed_request]
			fb_application = FbApplication.find(@application.fb_application_id)
			if fb_application
				@fb_user = FbUser.test_sign_in(@application.id, fb_application.app_id, fb_application.secret_key, params[:signed_request])
				unless @fb_user.api_key.length > 0
					@fb_user.api_key.create
				end
				render json: {
					id: @fb_user.id,
					name: @fb_user.name,
					identifier: @fb_user.identifier,
					api_key: @fb_user.api_key.last.token,
				}
			else
				raise ActiveRecord::RecordNotFound, "No fb_application found for ID #{@application.fb_application_id}"
			end
		else
			raise ParamsVerificationFailed, 'signed_request'
		end
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

	def get_application
		@application = Application.find_by(checksum: params[:checksum])
	end
end
