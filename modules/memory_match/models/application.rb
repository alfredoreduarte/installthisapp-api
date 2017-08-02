class Application

	def create_callback
		logger.info("/*/*/*/*/*/ MEMORY MATCH: CREATE CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_callback
		logger.info("/*/*/*/*/*/ MEMORY MATCH: INSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_callback
		logger.info("/*/*/*/*/*/ MEMORY MATCH: UNINSTALL CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def install_tab_callback
		logger.info("/*/*/*/*/*/ MEMORY MATCH: INSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

	def uninstall_tab_callback
		logger.info("/*/*/*/*/*/ MEMORY MATCH: UNINSTALL TAB CALLBACK: OVERRIDE THIS! /*/*/*/*/*/")
	end

end