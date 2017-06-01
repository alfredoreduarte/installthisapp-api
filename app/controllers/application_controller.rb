# class ApplicationController < ActionController::API
class ApplicationController < ActionController::Base
	respond_to :json
	protect_from_forgery with: :null_session
	include DeviseTokenAuth::Concerns::SetUserByToken
	before_action :configure_permitted_parameters, if: :devise_controller?
	# before_action :set_raven_context

	# edit
		# class ParamsVerificationFailed < ActionController::BadRequest; end
		ParamsVerificationFailed = Class.new(ActionController::BadRequest)
		# class ApiExceptionSerializer < ActiveModel::Serializer
			# attributes :status, :code, :message
		# end

		rescue_from ParamsVerificationFailed, :with => :render_error_response
		def render_error_response(error)
			# render json: error, serializer: ApiExceptionsSerializer, status: :bad_request
			render json: {
				message: error
			}, status: :bad_request
		end
	# edit

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
		devise_parameter_sanitizer.permit(:account_update, keys: [:name])
	end

	# 
	# Commented out because 
	# current_admin is undefined at this point
	# 
	# def set_raven_context
	# 	Raven.user_context(
	# 		id: current_admin.id,
	# 		email: current_admin.email
	# 	)
	# 	Raven.extra_context(
	# 		params: params.to_unsafe_h, 
	# 		url: request.url
	# 	)
	# end
end