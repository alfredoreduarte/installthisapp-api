class FbPagesController < ApplicationController
	before_action :authenticate

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
