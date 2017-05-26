class UninstallExpiredApps < ApplicationJob
	queue_as :default

	def perform
		Application.batch_uninstall_expired_apps
	end
end
