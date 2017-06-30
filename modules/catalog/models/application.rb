class Application

	def create_callback
		logger.info("/*/*/*/*/*/ CATALOG: CREATE CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_callback
		logger.info("/*/*/*/*/*/ CATALOG: INSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_callback
		logger.info("/*/*/*/*/*/ CATALOG: UNINSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_tab_callback
		logger.info("/*/*/*/*/*/ CATALOG: INSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_tab_callback
		logger.info("/*/*/*/*/*/ CATALOG: UNINSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

end