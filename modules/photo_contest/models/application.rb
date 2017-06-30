class Application
	
	def create_callback
		logger.info("/*/*/*/*/*/ PHOTO CONTEST: CREATE CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_callback
		logger.info("/*/*/*/*/*/ PHOTO CONTEST: INSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_callback
		logger.info("/*/*/*/*/*/ PHOTO CONTEST: UNINSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_tab_callback
		logger.info("/*/*/*/*/*/ PHOTO CONTEST: INSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_tab_callback
		logger.info("/*/*/*/*/*/ PHOTO CONTEST: UNINSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
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