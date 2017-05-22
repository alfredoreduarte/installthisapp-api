class ApplicationController < ActionController::Base
	# respond_to :json
	# protect_from_forgery with: :null_session
	include DeviseTokenAuth::Concerns::SetUserByToken
	# before_action :configure_permitted_parameters, if: :devise_controller?

	# 
	# Godview for super admins
	# Swaps the current authenticated super admin with a client account
	# 
	alias_method :devise_current_admin, :current_admin
	def current_admin
		if request.headers["spy-user"].to_i > 0
			devise_current_admin = Admin.find(request.headers["spy-user"].to_i)
		else
			devise_current_admin = Admin.find_by(uid: request.headers["uid"])
		end
	end

	def payola_can_modify_subscription?(subscription)
		subscription.owner == current_admin
	end

	# protected

	# def configure_permitted_parameters
		# devise_parameter_sanitizer.permit(:sign_up, keys: [:confirm_success_url])
		# devise_parameter_sanitizer.for(:sign_up) << :confirm_success_url
		# devise_parameter_sanitizer.permit(:sign_up)        << :confirm_success_url
	# end

	# def devise_parameter_sanitizer
	# 	Admin::ParameterSanitizer.new(Admin, :admin, params)
	# end

	# def configure_permitted_parameters
	# 	devise_parameter_sanitizer.permit(:sign_up) do |user_params|
	# 		user_params.permit({ roles: [] }, :email, :password, :password_confirmation, :confirm_success_url)
	# 	end
	# end
end