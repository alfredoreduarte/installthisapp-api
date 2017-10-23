class TwoCheckoutNotificationsController < ApplicationController

	def create
		notif = TwoCheckoutNotification.create(body: params.as_json)
		if notif.save
			render status: :ok, plain: :ok
		else
			render status: :error, plain: :ok
		end
	end

end
