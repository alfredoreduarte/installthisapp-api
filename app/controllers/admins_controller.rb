class AdminsController < ApplicationController
	before_action :authenticate_admin!, except: [:index]

	def entities
		@admin = current_admin
		@plans = SubscriptionPlan.all
	end

	def index
		# working:
		admins = Rails.cache.fetch("all_admins", :expires_in => 1.minute) do
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

	

	# private

	# def admin_user_params
		# params.require(:admin).permit(:name, :email)
	# end

	# caches_page   :index
end
