module FrontendController

	def settings
		respond_to do |format|
			format.json { render json: $application.setting.conf["preferences"] }
		end
	end
	
end