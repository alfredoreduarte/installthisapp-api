module BackendController

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@entries = @application.entries.order("elapsed_seconds DESC")
	end

end
