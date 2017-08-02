module BackendController

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@photos = @application.photos
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

	def votes_destroy
		votes = @application.votes.find(params[:id])
		votes.each do |vote|
			vote.destroy
		end
		respond_to do |format|
			format.json { render json: {status: 'ok'} }
		end
	end
	
end
