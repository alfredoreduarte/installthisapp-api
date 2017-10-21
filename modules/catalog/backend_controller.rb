module BackendController
	# Cannot use callbacks on modules, only on subclasses of ApplicationController
	# This is an argument in favor of turning modules into engines
	# before_action :set_product, only: [:products_update, :products_destroy]

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@products = @application.products
		@categories = @application.categories
		@media = @application.media
	end

	# 
	# Products
	# 

	# POST /applications/[checksum]/products_create.json
	def products_create
		@product = @application.products.new(product_params)
		if @product.save
			render "applications/products/show", status: :ok
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /applications/[checksum]/products_update.json
	def products_update
		set_product
		if @product.update(product_params)
			render "applications/products/show", status: :ok
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# DELETE /applications/[checksum]/products_destroy.json
	def products_destroy
		set_product
		@product.destroy
		head :no_content
	end

	# 
	# Categories
	# 

	# POST /applications/[checksum]/categories_create.json
	def categories_create
		@category = @application.categories.new(category_params)
		if @category.save
			render "applications/categories/show", status: :ok
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /applications/[checksum]/categories_update.json
	def categories_update
		set_category
		if @category.update(category_params)
			render "applications/categories/show", status: :ok
		else
			render json: @category.errors, status: :unprocessable_entity
		end
	end

	# DELETE /applications/[checksum]/categories_destroy.json
	def categories_destroy
		set_category
		@category.destroy
		head :no_content
	end

	# 
	# Media
	# 

	# POST /applications/[checksum]/media_create.json
	def media_create
		@medium = @application.media.new(medium_params)
		if @medium.save
			render "applications/media/show", status: :ok
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /applications/[checksum]/media_update.json
	def media_update
		set_medium
		if @medium.update(medium_params)
			render "applications/media/show", status: :ok
		else
			render json: @medium.errors, status: :unprocessable_entity
		end
	end

	# DELETE /applications/[checksum]/media_destroy.json
	def media_destroy
		set_medium
		@medium.destroy
		head :no_content
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_product
			@product = @application.products.find(params[:id])
		end

		def set_medium
			@medium = @application.media.find(params[:id])
		end

		def set_category
			@category = @application.categories.find(params[:id])
		end

		def product_params
			params.require(:product).permit(
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
				{:category_ids => []},
				:featured_image_id,
				{:gallery_media_ids => []},
			)
		end

		def category_params
			params.require(:category).permit(
				:name,
				:parent_id,
				:slug,
			)
		end

		def medium_params
			params.require(:medium).permit(
				:attachment_url,
				:attachment_type,
				:attachment_alt,
			)
		end

end
