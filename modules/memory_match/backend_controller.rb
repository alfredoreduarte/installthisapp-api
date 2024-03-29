module BackendController

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@entries = @application.entries
		@cards = @application.cards
	end

	def cards_create
		@card = @application.cards.create(card_params)
	end

	def cards_destroy
		card = @application.cards.find(params[:id])
		if card
			card.destroy
		end
		render json: {status: 'ok'}
	end

	def entries_destroy
		entry = @application.entries.find(params[:id])
		if entry
			entry.destroy
		end
		# respond_to do |format|
			render json: {status: 'ok'}
		# end
	end

	private

	def card_params
		params.require(:card).permit(:id, :attachment_url)
	end

end
