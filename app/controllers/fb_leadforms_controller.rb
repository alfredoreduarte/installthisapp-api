class FbLeadformsController < ApplicationController
	before_action :set_fb_leadform, only: [:show, :update, :destroy]

	# GET /purchases
	# GET /purchases.json
	def index
		@fb_leadforms = current_admin.fb_leadforms.order(:created_at)
	end

	# POST /purchases
	# POST /purchases.json
	def create
		@fb_leadform = current_admin.fb_leadforms.new(fb_leadform_params)

		respond_to do |format|
			if @fb_leadform.save
				format.json { render :show, status: :created, location: @fb_leadform }
			else
				format.json { render json: @fb_leadform.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /purchases/1
	# DELETE /purchases/1.json
	def destroy
		@fb_leadform.destroy
		respond_to do |format|
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_fb_leadform
			@fb_leadform = current_admin.fb_leadforms.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def fb_leadform_params
			params.require(:fb_leadform).permit(:fb_page_identifier, :fb_form_id)
		end

end
