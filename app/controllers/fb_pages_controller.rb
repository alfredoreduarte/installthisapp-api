class FbPagesController < ApplicationController

	# GET /fetch_leadgen_forms
	# GET /fetch_leadgen_forms.json
	def fetch_leadgen_forms
		require 'fb_api'
		if params[:identifier]
			fb_page = current_admin.fb_pages.find_by(identifier: params[:identifier])
			if fb_page
				result = FbApi::retrieve_fb_page_leadgen_forms(fb_page.identifier, current_admin.fb_profile.access_token)
			end
		end
		if result
			render json: result, status: :ok
		else
			render json: {success: false}, status: :unprocessable_entity
		end
	end

end
