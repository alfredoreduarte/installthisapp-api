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

	private

	def card_params
		params.require(:card).permit(:id, :attachment_url)
	end

end
