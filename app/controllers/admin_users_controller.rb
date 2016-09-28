class AdminUsersController < ApplicationController
	before_action 	:authenticate, except: [:create, :jsonmock]
	before_action 	:set_admin, except: [:create, :jsonmock]

	def index
		respond_to do |format|
			format.json { render json: $admin_user.as_json }
		end
	end

	def create
		# logger.info('monguito')
		# TopFansLike.create(post_id: 123,user_identifier: 456,user_name: "Alf staging",page_id: 1928)
		# TopFansLike.create(post_id: 123,user_identifier: 456,user_name: "Alf Dev!",page_id: 1928)
		# logger.info('monguito')
		$admin_user = AdminUser.sign_in(params[:signed_request])
		unless $admin_user.api_key.length > 0
			$admin_user.api_key.create
		end
		render plain: $admin_user.api_key.last.token
	end

	def show
		response = {
			apps: $admin_user.applications.as_json(include: [:users, :fb_application]),
			pages: $admin_user.fb_pages,
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def update
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
