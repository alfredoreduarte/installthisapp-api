class FbProfilesController < ApplicationController
	before_action :authenticate_admin!

	def create
		current_admin.fb_profile = FbProfile.new
		current_admin.fb_profile.signed_request = params[:authResponse][:signedRequest]
		if current_admin.fb_profile.sign_in
			current_admin.fb_profile.save
			render json: {
				status: 'success',
				data: current_admin.fb_profile.as_json
			}
		else
			render json: {
				status: 'error'
			}
		end
	end

	def fetch_fb_pages
		current_admin.fb_profile.fetch_fb_pages
		render json: { pages: current_admin.fb_profile.fb_pages.as_json(only: [:identifier, :name, :like_count]) }
	end
end
