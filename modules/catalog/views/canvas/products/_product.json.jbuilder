json.extract! product,
	:id,
	# :application_id,
	:name,
	:slug,
	# :status,
	:featured,
	:description,
	:short_description,
	:price,
	:regular_price,
	:sale_price,
	:on_sale_from,
	:on_sale_to,
	:menu_order,
	:featured_image,
	# :gallery_media_ids,
	# :category_ids,
	# :categories,
	# :media,
	:permalink,
	:created_at
json.media do
	json.array! product.media, partial: 'canvas/media/medium', as: :medium
end
json.categories do
	json.array! product.categories, partial: 'canvas/categories/category', as: :category
end