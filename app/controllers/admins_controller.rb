class AdminsController < ApplicationController
	before_action :authenticate_admin!, except: [:jsonmock]
	# before_action :authenticate_admin!, except: [:jsonmock, :index]
	# before_action 	:authenticate, except: [:create, :jsonmock]
	# before_action 	:set_admin, except: [:create, :jsonmock]

	def entities
		@admin = current_admin
		@plans = SubscriptionPlan.all
	end

	def index
		# working:
		admins = Rails.cache.fetch("all_adminss", :expires_in => 1.minute) do
			Admin.all
		end
		render json: admins.as_json
		# 		
		# results_likes = TopFansLike.likes_by_page(272699880986)
		# render json: results_likes.first(3).as_json
	end

	# def create
		# $admin_user = Admins.sign_in(params[:signed_request])
		# unless $admin_user.api_key.length > 0
			# $admin_user.api_key.create
		# end
		# render plain: $admin_user.api_key.last.token
	# end

	# def show
		# response = {
			# admin_user: $admin_user.as_json(
				# include: {
					# applications: {
						# include: [:users, :fb_application, :fb_page, :setting],
					# },
	# 				fb_pages: {}
	# 			}
	# 		),
	# 	}
	# 	respond_to do |format|
	# 		format.json { render json: response }
	# 	end
	# end

	# def update
	# 	$admin_user.update_attributes(admin_user_params)
	# 	respond_to do |format|
	# 		format.json { render json: $admin_user.as_json }
	# 	end
	# end

	# Godview data
	def jsonmock
		@admins = Admin.includes(:applications)
		@apps = Application.all
		@active_apps = Application.installed.all
		@pages = FbPage.all
		@fb_apps = FbApplication.all
		respond_to do |format|
			format.json
		end
	end

	# private

	# def admin_user_params
	# 	params.require(:admin_user).permit(:name, :email)
	# end

	# caches_page   :index
end
