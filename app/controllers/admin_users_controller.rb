class AdminUsersController < ApplicationController
	before_action 	:authenticate, except: [:create, :jsonmock]
	before_action 	:set_admin, except: [:create, :jsonmock]

	def index
		respond_to do |format|
			format.json { render json: AdminUser.all.as_json }
		end
	end

	def create
		$admin_user = AdminUser.sign_in(params[:signed_request])
		unless $admin_user.api_key.length > 0
			$admin_user.api_key.create
		end
		render plain: $admin_user.api_key.last.token
	end

	def show
		response = {
			admin_user: $admin_user.as_json(
				include: {
					applications: {
						include: [:users, :fb_application, :fb_page]
					},
					fb_pages: {}
				}
			),
			# apps: $admin_user.applications.as_json(include: [:users, :fb_application]),
			# pages: $admin_user.fb_pages,
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def update
		1 / 0
		$admin_user.update_attributes(admin_user_params)
		respond_to do |format|
			format.json { render json: $admin_user.as_json }
		end
	end

	# Godview data
	def jsonmock
		@admin_users = AdminUser.includes(:applications)
		@apps = Application.all
		@active_apps = Application.installed.all
		@pages = FbPage.all
		@fb_apps = FbApplication.all
		respond_to do |format|
			format.json
		end
	end

	private

	def admin_user_params
		params.require(:admin_user).permit(:name, :email)
	end
end
