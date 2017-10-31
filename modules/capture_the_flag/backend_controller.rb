module BackendController

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@entries = @application.entries
	end

end
