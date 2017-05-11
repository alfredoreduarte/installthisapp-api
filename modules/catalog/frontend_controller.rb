module FrontendController

	def settings
		respond_to do |format|
			format.json { render json: $application.setting.conf["preferences"] }
		end
	end

	def entities
		@application = $application
		@products = @application.products.published
		# @products = @application.products.published.includes(:categories, :media)
		# categories array
		category_ids = []
		otrosids = []
		category_ids = @products.map{|p| otrosids = otrosids + p.category_ids}
		otrosids = otrosids.map(&:to_i)
		@categories = @application.categories.where(["id IN (?)", otrosids])
		# media array
		gallery_media_ids = []
		otrosids = []
		gallery_media_ids = @products.map{|p| otrosids = otrosids + p.gallery_media_ids}
		otrosids = otrosids.map(&:to_i)
		@media = @application.media.where(["id IN (?)", otrosids])
	end
	
end