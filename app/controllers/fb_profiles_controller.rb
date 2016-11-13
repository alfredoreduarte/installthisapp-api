class FbProfilesController < ApplicationController
	before_action :authenticate_admin!

	def create
		current_admin.fb_profile = FbProfile.where(identifier: params[:identifier]).first_or_initialize
		current_admin.fb_profile.signed_request = params[:signed_request]
		if current_admin.fb_profile.sign_in
			current_admin.fb_profile.save
			current_admin.fb_profile.fetch_fb_pages
			@admin = current_admin
			render 'admins/entities'
		else
			render json: {
				status: 'error'
			}
		end
	end

	def fetch_fb_pages
		current_admin.fb_profile.fetch_fb_pages
		response = {
			pages: current_admin.fb_profile.fb_pages,
		}
		render json: response
	end
end
