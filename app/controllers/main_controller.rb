class MainController < ApplicationController
	# before_action :authenticate_admin!, except: [:index]
	# before_action :authenticate_admin!
	def index
		render plain: 'Server is up and running'
	end
end
