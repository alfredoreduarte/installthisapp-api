module BackendController

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@vouchers = @application.vouchers
	end

	def vouchers_create
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		if params[:mode] == 'auto'
			quantity = params[:quantity].to_i
			quantity.times do |i|
				code = SecureRandom.hex(3)
				loop do
					code = SecureRandom.hex(3)
					break if @application.vouchers.find_by(code: code).nil?
				end
				@application.vouchers.create(code: code)
			end
		elsif params[:mode] == 'custom'
			quantity = params[:codes].count
			quantity.times do |i|
				@application.vouchers.create(code: params[:codes][i])
			end
		end
		@vouchers = @application.vouchers
	end

	def vouchers_destroy
		voucher = @application.vouchers.find(params[:id])
		if voucher
			voucher.destroy
		end
		render json: { status: 'ok' }
	end

	private

	def voucher_params
		params.require(:voucher).permit(:id, :code)
	end

end
