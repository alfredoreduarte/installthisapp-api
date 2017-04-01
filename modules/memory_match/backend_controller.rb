module BackendController

	def settings
		render json: @application.setting
	end

	def entities
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
		respond_to do |format|
			format.json { render json: {status: 'ok'} }
		end
	end

	def entries_destroy
		entry = @application.entries.find(params[:id])
		if entry
			entry.destroy
		end
		respond_to do |format|
			format.json { render json: {status: 'ok'} }
		end
	end

	private

	def card_params
		params.require(:card).permit(:id, :attachment_url)
	end

end
