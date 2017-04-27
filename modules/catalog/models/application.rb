class Application

	def create_callback
		logger.info("/*/*/*/*/*/ CREATE CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_callback
		logger.info("/*/*/*/*/*/ INSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_callback
		logger.info("/*/*/*/*/*/ UNINSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_tab_callback
		logger.info("/*/*/*/*/*/ INSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_tab_callback
		logger.info("/*/*/*/*/*/ UNINSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

end