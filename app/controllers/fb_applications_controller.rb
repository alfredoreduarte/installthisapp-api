class FbApplicationsController < ApplicationController
	def index
		response = FbApplication.all.as_json
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def create
		# hash = params.deep_symbolize_keys
		# logger.info('losparams')
		# logger.info(params.inspect)
		# fbApp = FbApplication.create(
			# name: hash[:name],
			# app_id: hash[:appId],
			# secret_key: hash[:secret_key],
		# 	application_type: hash[:application_type],
		# 	canvas_id: hash[:canvas_id],
		# 	namespace: hash[:namespace]
		# )
		# if fbApp.valid?
		# 	response = {
		# 		id: fbApp.id,
		# 		name: fbApp.name,
		# 		app_id: fbApp.app_id,
		# 		secret_key: fbApp.secret_key,
		# 		application_type: fbApp.application_type,
		# 		canvas_id: fbApp.canvas_id,
		# 		namespace: fbApp.namespace
		# 	}
		# else
		# 	response = {
		# 		error: fbApp.errors.full_messages,
		# 	}
		# end
		@fb_application = FbApplication.create(fb_application_params)
		if @fb_application.valid?
			response = @fb_application.as_json
		else
			response = {
				error: fbApp.errors.full_messages,
			}
		end
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def destroy
		@fbApp = FbApplication.find(params[:id])
		if @fbApp.destroy
			response = {
				status: 'ok',
			}
		else
			response = {
				status: @fbApp.errors.full_messages,
			}
		end
		respond_to do |format|
			format.json { render json: response }
		end
	end

	private

	def fb_application_params
		params.require(:fb_application).permit(
			:name,
			:app_id,
			:secret_key,
			:application_type,
			:canvas_id,
			:namespace,
		)
	end
end
