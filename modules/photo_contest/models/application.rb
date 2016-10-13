class Application
	def create_callback
	end

	def install_callback
		logger.info("/*/*/*/*/*/ INSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_callback
		logger.info("/*/*/*/*/*/ UNINSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def stats_summary
		return {
			stats_summary: [
				{
					label: 'Users',
					value: self.fb_users.count
				},
				{
					label: 'Photos',
					value: self.photos.count
				},
				{
					label: 'Average votes per photo',
					value: self.photos.average(:votes_count).to_i || 0
				},
				{
					label: 'Votes for top photo',
					value: self.photos.maximum(:votes_count) || 0
				},
			]
		}
	end
end