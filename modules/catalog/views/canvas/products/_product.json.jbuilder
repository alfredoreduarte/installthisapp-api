json.ignore_nil! false
json.extract! product,
	:id,
	:name,
	:slug,
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
	:permalink,
	:created_at
json.media do
	json.array! product.media, partial: 'canvas/media/medium', as: :medium
end
json.categories do
	json.array! product.categories, partial: 'canvas/categories/category', as: :category
end