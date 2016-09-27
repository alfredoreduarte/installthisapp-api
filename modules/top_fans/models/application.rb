class Application
	def create_callback
	end

	def uninstall_callback
		if self.fb_page
			self.fb_page.unsubscribe_to_realtime($admin_user)
		end			
	end

	def install_callback
		if self.fb_page
			self.fb_page.subscribe_to_realtime($admin_user, self.fb_application)
		end
	end
end