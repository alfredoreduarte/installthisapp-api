class FbApplicationsController < ApplicationController
	def index
		response = FbApplication.all.as_json
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def create
		hash = params.deep_symbolize_keys
		fbApp = FbApplication.create(
			name: hash[:name],
			app_id: hash[:applicationId],
			secret_key: hash[:secretCode],
			application_type: hash[:type],
			canvas_id: hash[:canvasId],
			namespace: hash[:namespace]
		)
		if fbApp.valid?
			response = {
				id: fbApp.id,
				name: fbApp.name,
				applicationId: fbApp.app_id,
				secretCode: fbApp.secret_key,
				type: fbApp.application_type,
				canvasId: fbApp.canvas_id,
				namespace: fbApp.namespace
			}
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
end
