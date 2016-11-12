class ApplicationController < ActionController::Base
	# respond_to :json
	include DeviseTokenAuth::Concerns::SetUserByToken

	# 
	# Godview for super admins
	# Swaps the current authenticated super admin with a client account
	# 
	# alias_method :devise_current_admin, :current_admin
	# def current_admin
	# 	if request.headers["spy-user"].to_i > 0
	# 		devise_current_admin = Admin.find(request.headers["spy-user"].to_i)
	# 	else
	# 		devise_current_admin = Admin.find_by(uid: request.headers["uid"])
	# 	end
	# end
end