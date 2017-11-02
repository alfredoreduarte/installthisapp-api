module BackendController

	def msg
		@application.entries.first.enqueue_email
		render json: {success: true}
	end

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@entries = @application.entries
		@schema = @application.schema
	end

	def save
		schema = @application.schema || @application.build_schema(application_id: @application.id)
		schema.structure = params[:schema]
		schema.save
		render json: schema
	end

end
