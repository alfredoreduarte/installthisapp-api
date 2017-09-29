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

	def resend_email_confirmation
		current_admin.resend_confirmation_instructions
		# 
		# Simulating admins#entities
		# TODO: corregir esto en el futuro
		# 
		@admin = current_admin
		@plans = SubscriptionPlan.all
		render 'admins/entities'
	end
	
end
