json.products do
	json.array! @products, partial: 'applications/products/product', as: :product
end
json.media do
	json.array! @media, partial: 'applications/media/medium', as: :medium
end
json.categories do
	json.array! @categories, partial: 'applications/categories/category', as: :category
end