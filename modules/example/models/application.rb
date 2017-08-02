class Application

	def create_callback
		logger.info("/*/*/*/*/*/ EXAMPLE: CREATE CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_callback
		logger.info("/*/*/*/*/*/ EXAMPLE: INSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_callback
		logger.info("/*/*/*/*/*/ EXAMPLE: UNINSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_tab_callback
		logger.info("/*/*/*/*/*/ EXAMPLE: INSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_tab_callback
		logger.info("/*/*/*/*/*/ EXAMPLE: UNINSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

end