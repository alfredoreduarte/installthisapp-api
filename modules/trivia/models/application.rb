class Application
	def create_callback
	end

	def install_callback
		logger.info("/*/*/*/*/*/ TRIVIA: INSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_callback
		logger.info("/*/*/*/*/*/ TRIVIA: UNINSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_tab_callback
		logger.info("/*/*/*/*/*/ TRIVIA: UNINSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_tab_callback
		logger.info("/*/*/*/*/*/ TRIVIA: UNINSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def stats_summary
		return {
			stats_summary: [
				{
					label: 'Users',
					value: self.fb_users.count
				},
				{
					label: 'Average score',
					value: self.average_score_all_users
				},
				{
					label: 'Max. score',
					value: "#{self.user_summaries.maximum(:qualification).to_i}%"
				},
			]
		}
	end

	def average_score_all_users
		return "#{self.user_summaries.average(:qualification).to_i || 0}%"
	end
end