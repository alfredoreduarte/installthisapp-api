module FrontendController

	def entities
		@schema = @application.schema
	end

	def unauthenticated_entries_create
		@entry = @application.entries.new(payload: params[:entry])
		if @entry.save
			@success = true
		else
			@success = false
		end
	end
	
end