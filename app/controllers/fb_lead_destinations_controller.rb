class FbLeadDestinationsController < ApplicationController
	before_action :set_fb_lead_destination, only: [:show, :update, :destroy]

	# GET /purchases
	# GET /purchases.json
	def index
		@fb_lead_destinations = current_admin.fb_lead_destinations.order(:created_at)
	end

	# POST /purchases
	# POST /purchases.json
	def create
		# @fb_lead_destination = current_admin.fb_leadforms.find(params[:fb_leadform_id]).fb_lead_destinations.new(fb_lead_destination_params)
		fb_leadform = current_admin.fb_leadforms.find(params[:fb_leadform_id])
		@fb_lead_destination = current_admin.fb_lead_destinations.new(fb_lead_destination_params)
		# @fb_lead_destination.fb_leadform = fb_leadform

		respond_to do |format|
			if @fb_lead_destination.save
				format.json { render :show, status: :created, location: @fb_lead_destination }
			else
				format.json { render json: @fb_lead_destination.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /purchases/1
	# DELETE /purchases/1.json
	def destroy
		@fb_lead_destination.destroy
		respond_to do |format|
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_fb_lead_destination
			@fb_lead_destination = current_admin.fb_lead_destinations.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def fb_lead_destination_params
			params.require(:fb_lead_destination).permit(:destination_type, :status, :settings, fb_leadform_ids: [])
		end
end
