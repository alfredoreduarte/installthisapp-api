module BackendController
	def photos
		response = {
			photos: @application.photos.as_json(
				except: [:attachment_file_name, :attachment_content_type],
				include: {
					votes: {
						include: [
							user: {
								only: [:id, :identifier, :name]
							}
						]
					}, 
					user: {
						only: [:id, :identifier, :name]
					}
				}, methods: [:thumbnail_url, :asset_url] )
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def photos_destroy
		photos = @application.photos.find(params[:id])
		photos.each do |photo|
			photo.destroy
		end
		respond_to do |format|
			format.json { render json: {status: 'ok'} }
		end
	end
end
