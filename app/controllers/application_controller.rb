class ApplicationController < ActionController::API
	respond_to :json

	# These two inclusions allow us to use authenticate_or_request_with_http_token at canvas_controller
	# because they're not included by default when using ActionController::API
	include ActionController::HttpAuthentication::Basic::ControllerMethods
	include ActionController::HttpAuthentication::Token::ControllerMethods
	include ActionController::Cookies

	include DeviseTokenAuth::Concerns::SetUserByToken
	prepend_before_action :configure_permitted_parameters, if: :devise_controller?

	# 
	# Custom error types
	# We're not rescuing from any in order to get notified about them
	# 
	# class ParamsVerificationFailed < ActionController::BadRequest; end
	# rescue_from ParamsVerificationFailed, :with => :render_error_response
	# def render_error_response(error)
	# 	render json: {
	# 		message: error
	# 	}, status: :bad_request
	# end
	ParamsVerificationFailed = Class.new(ActionController::ParameterMissing)

	# 
	# GodWiew for super admins
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

	protected

	# 
	# Allow extra params for signup, update, etc.
	# https://github.com/plataformatec/devise#strong-parameters
	# 
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
		devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email])
	end

	def confirm_first
		Admin.first.resend_confirmation_instructions
	end
end