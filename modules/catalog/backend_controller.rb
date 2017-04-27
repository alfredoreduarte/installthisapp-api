module BackendController

	def settings
		render json: @application.setting
	end

end
