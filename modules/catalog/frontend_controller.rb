module FrontendController

	def entities
		@application = $application
		@products = @application.products.published
	end

	# 
	# Messages
	# 

	# POST /[checksum]/messages_create.json
	def messages_create
		@message = $application.messages.new(message_params)
		recipients_from_settings = $application.setting.conf["preferences"]["message_recipients"]
		@message.recipients = recipients_from_settings.length > 0 ? recipients_from_settings.lenght : $application.admin.email
		respond_to do |format|
			if @message.save
				format.json { render json: {
					success: true
				}, status: :ok }
			else
				format.json { render json: @message.errors, status: :unprocessable_entity }
			end
		end
	end

	private

		def message_params
			params.require(:message).permit(
				:email,
				:product_id,
				:phone,
				:content,
			)
		end
	
end