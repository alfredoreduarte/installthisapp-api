module BackendController

	def settings
		render json: @application.setting
	end

	# 
	# Products
	# 

	def products_create
		@product = @application.products.create(product_params)
	end

	# 
	# Categories
	# 

	def categories_create
		@category = @application.categories.create(category_params)
	end

	# 
	# Media
	# 

	def media_create
		@medium = @application.media.create(medium_params)
	end

	private

	def product_params
		params.require(:product).permit(
			# :id,
			:name,
			:slug,
			:status,
			:featured,
			:description,
			:short_description,
			:price,
			:regular_price,
			:sale_price,
			:on_sale_from,
			:on_sale_to,
			:menu_order,
			:category_ids,
			:featured_image_id,
			:gallery_media_ids,
		)
	end

	def category_params
		params.require(:category).permit(
			# :id,
			:name,
			:parent_id,
		)
	end

	def medium_params
		params.require(:medium).permit(
			# :id,
			:attachment_url,
			:attachment_type,
			:attachment_alt,
		)
	end

end
