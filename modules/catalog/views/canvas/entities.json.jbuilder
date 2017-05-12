json.products do
	json.array! @products, partial: 'canvas/products/product', as: :product
end