class FbLeadformsController < ApplicationController
	before_action :set_fb_leadform, only: [:show, :update, :destroy, :test, :get_existing_test_lead]

	# GET /fb_leadforms
	# GET /fb_leadforms.json
	def index
		@fb_leadforms = current_admin.fb_leadforms.order(:created_at)
	end

	# GET /fb_leadforms/1/get_existing_test_lead.json
	def get_existing_test_lead
		result = @fb_leadform.get_existing_test_lead
		if result
			render json: result
		else
			render json: @fb_leadform.errors, status: :ok
		end
	end

	# PATCH/PUT /fb_leadforms/1
	# PATCH/PUT /fb_leadforms/1.json
	def test
		result = @fb_leadform.test
		if result
			render json: result
		else
			render json: @fb_leadform.errors, status: :ok
		end
	end

	def poll_test_arrival
		fb_lead = FbLead.find_by(lead_id: params[:lead_id])
		if fb_lead
			render json: fb_lead
		else
			render json: nil, status: :ok
		end
	end

	def poll_test_notification_delivery
		fb_lead_notification = FbLeadNotification.find_by(lead_id: params[:lead_id])
		if fb_lead_notification
			render json: fb_lead_notification
		else
			render json: nil, status: :ok
		end
	end

	# POST /fb_leadforms
	# POST /fb_leadforms.json
	def create
		@fb_leadform = current_admin.fb_leadforms.new(fb_leadform_params)
		if @fb_leadform.save
			render :show, status: :created, location: @fb_leadform
		else
			render json: @fb_leadform.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /fb_leadforms/1
	# PATCH/PUT /fb_leadforms/1.json
	def update
		if @fb_leadform.update(fb_leadform_params)
			render :show, status: :ok, location: @fb_leadform
		else
			render json: @fb_leadform.errors, status: :unprocessable_entity
		end
	end

	# DELETE /fb_leadforms/1
	# DELETE /fb_leadforms/1.json
	def destroy
		@fb_leadform.destroy
		head :no_content
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_fb_leadform
			@fb_leadform = current_admin.fb_leadforms.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def fb_leadform_params
			params.require(:fb_leadform).permit(:fb_page_identifier, :fb_form_id, :fb_form_name)
		end

end
