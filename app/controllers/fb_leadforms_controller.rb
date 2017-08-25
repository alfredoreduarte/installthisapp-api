class FbLeadformsController < ApplicationController
	before_action :set_fb_leadform, only: [:show, :update, :destroy, :test]

	# GET /fb_leadforms
	# GET /fb_leadforms.json
	def index
		@fb_leadforms = current_admin.fb_leadforms.order(:created_at)
	end

	# PATCH/PUT /fb_leadforms/1
	# PATCH/PUT /fb_leadforms/1.json
	def test
		respond_to do |format|
			if @fb_leadform.test
				format.json { render :show, status: :ok, location: @fb_leadform }
			else
				format.json { render json: @fb_leadform.errors, status: :unprocessable_entity }
			end
		end
	end

	# POST /fb_leadforms
	# POST /fb_leadforms.json
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

	# PATCH/PUT /fb_leadforms/1
	# PATCH/PUT /fb_leadforms/1.json
	def update
		respond_to do |format|
			if @fb_leadform.update(fb_leadform_params)
				format.json { render :show, status: :ok, location: @fb_leadform }
			else
				format.json { render json: @fb_leadform.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /fb_leadforms/1
	# DELETE /fb_leadforms/1.json
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
