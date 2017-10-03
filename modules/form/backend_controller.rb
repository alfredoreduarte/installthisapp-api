module BackendController

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@entries = @application.entries
		@schema = @application.schema
	end

	def save
		logger.info(params[:schema])
		logger.info(@application)
		schema = @application.schema || @application.build_schema(application_id: @application.id)
		schema.structure = params[:schema]
		schema.save
		render json: schema
	end

end
