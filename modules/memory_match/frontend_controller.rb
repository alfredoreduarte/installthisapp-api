module FrontendController

	def entities
		@application = @application
		logger.info('elentry')
		logger.info(@application.setting.conf["preferences"]["play_multiple_times"])
		if @application.setting.conf["preferences"]["play_multiple_times"] == false and @fb_user.entry
			@cards = []
		else
			@cards = @application.cards
		end
	end

	def entries_create
		starting_time = Time.at(entry_params[:starting_time])
		finish_time = Time.at(entry_params[:finish_time])
		time = (finish_time - starting_time).to_i
		clicks = entry_params[:clicks]
		# @entry = @application.entries.new(clicks: clicks, time: time)
		@entry = @application.entries.find_or_create_by(fb_user_id: @fb_user.id)
		@entry.clicks = clicks
		@entry.time = time
		if @entry.save
			@success = true
		else
			@success = false
		end
	end

	private

	def entry_params
		params.require(:entry).permit(:clicks, :starting_time, :finish_time)
	end
	
end