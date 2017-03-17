module BackendController

	def settings
		render json: @application.setting
	end

	def entities
		@entries = @application.entries
	end

end
