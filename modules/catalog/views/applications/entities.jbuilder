json.products do
	json.array! @products, partial: 'applications/product', as: :product
end