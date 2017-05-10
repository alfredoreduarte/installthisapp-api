json.products do
	json.array! @products, partial: 'canvas/products/product', as: :product
end
json.media do
	json.array! @media, partial: 'canvas/media/medium', as: :medium
end
json.categories do
	json.array! @categories, partial: 'canvas/categories/category', as: :category
end