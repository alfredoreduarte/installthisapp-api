class Application

	def create_callback
	end

	def uninstall_callback
		fb_page = nil
		if self.app_integrations.fb_webhook_page_feed.first
			fb_page = FbPage.find_by(identifier: self.app_integrations.fb_webhook_page_feed.first.settings["fb_page_identifier"])
		else
			fb_page = self.fb_page
		end
		if fb_page
			logger.info('Top Fans Uninstall Callback: Page found')
			fb_page.unsubscribe_to_realtime(self.admin)
			# 
			# Remove starting date so that the next time user tries to install the tab there's no cached date
			# 
			# Sometimes people would re-install selecting "track only new interactions" 
			# but the app would instead fetch past posts because it had a previously saved starting date
			# 
			self.setting.conf["preferences"]["first_fetch_from_date"] = nil
			self.setting.save
			TopFansLike.where(
				page_id: fb_page.identifier,
			).delete
			TopFansComment.where(
				page_id: fb_page.identifier,
			).delete
			self.app_integrations.fb_webhook_page_feed.destroy_all
		else
			logger.info('Top Fans Uninstall Callback: Tried to delete data on an app with no fb_page')
		end
	end

	def install_callback
	end

	def uninstall_tab_callback
		# self.uninstall
		# if self.fb_page
		# 	self.fb_page.unsubscribe_to_realtime(self.admin)
		# 	# 
		# 	# Remove starting date so that the next time user tries to install the tab there's no cached date
		# 	# 
		# 	# Sometimes people would re-install selecting "track only new interactions" 
		# 	# but the app would instead fetch past posts because it had a previously saved starting date
		# 	# 
		# 	self.setting.conf["preferences"]["first_fetch_from_date"] = nil
		# 	self.setting.save
		# 	TopFansLike.where(
		# 		page_id: self.fb_page.identifier,
		# 	).delete
		# 	TopFansComment.where(
		# 		page_id: self.fb_page.identifier,
		# 	).delete
		# else
		# 	logger.info('Tried to execute uninstall_tab_callback on an app with no fb_page')
		# end
	end

	def install_tab_callback
		# if self.fb_page
		# 	self.fb_page.subscribe_to_realtime(self.admin, self.fb_application)
		# 	if self.setting.conf["preferences"]["first_fetch_from_date"]
		# 		TopFansLike.where(
		# 			page_id: self.fb_page.identifier,
		# 		).delete
		# 		TopFansComment.where(
		# 			page_id: self.fb_page.identifier,
		# 		).delete
		# 		start_date = self.setting.conf["preferences"]["first_fetch_from_date"].to_datetime.to_i
		# 		identifier = self.fb_page.identifier
		# 		access_token = self.admin.fb_profile.access_token
		# 		TopFansResetJob.perform_later(identifier, access_token, start_date)
		# 	end
		# end
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
					value: 0
				},
				{
					label: 'Max. score',
					value: 0
				},
				{
					label: 'Average likes per user',
					value: 0
				},
			]
		}
	end
end

