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
		# respond_to do |format|
			if result
				# format.json { render json: result, status: :ok }
				render json: result, status: :ok
			else
				# format.json { render json: {success: false}, status: :unprocessable_entity }
				render json: {success: false}, status: :unprocessable_entity
			end
		# end
	end

	# def fetch
	# 	total_likes_count = 0
	# 	fb_pages = []
	# 	profile = $admin_user.get_fb_profile
	# 	fan_pages = profile.accounts({
	# 		:fields => "id, name, likes, country_page_likes"
	# 		}).collect{|p| p unless p.category=="Application"}.compact
	# 	unless fan_pages.nil?
	# 		for fan_page in fan_pages
	# 			fb_page = FbPage.save_basic_data(fan_page)
	# 			total_likes_count += fb_page.fan_count
	# 			fb_pages << fb_page
	# 		end
	# 		$admin_user.total_likes_count = total_likes_count
	# 		$admin_user.fb_pages = fb_pages
	# 		$admin_user.save
	# 	end
	# 	response = {
	# 		apps: $admin_user.applications,
	# 		pages: $admin_user.fb_pages,
	# 	}
	# 	respond_to do |format|
	# 		format.json { render json: response }
	# 	end
	# end
end
