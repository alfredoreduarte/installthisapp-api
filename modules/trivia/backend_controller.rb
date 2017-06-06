module BackendController

	def entities
		@application_log = ApplicationLog.log_by_checksum(@application.checksum)
		@questions = @application.questions
		@answers = @application.user_summaries
	end

	def questions_create
		# hash = params.deep_symbolize_keys
		question = @application.questions.create(question_params)
		response = {
			questions: [
				@application.questions.find(question.id).as_json(include: :options)
			]
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def questions_update
		hash = params.deep_symbolize_keys
		question = @application.questions.find(hash[:question][:id])
		question.update(question_params)
		response = {
			questions: [
				@application.questions.find(question.id).as_json(include: :options)
			]
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def questions_destroy
		questions = @application.questions.find(params[:id])
		questions.each do |question|
			question.destroy
		end
		response = {status: 'ok'}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def answers
		respond_to do |format|
			format.json { answers_json }
		end
	end

	def answers_destroy
		response = {status: 'ok'}
		summaries = @application.user_summaries.find(params[:id])
		summaries.each do |summary|
			unless summary.destroy
				response = {status: 'error'}
			end
		end
		respond_to do |format|
			format.json { render json: response }
		end
	end

	private

	def question_params
		params.require(:question).permit(:id, :text, :active, :application_id, options_attributes: [:id, :text, :correct, :position, :question_id, :_destroy])
	end

	def answers_json
		@answers = @application.user_summaries.includes(:answers)
		render json: @answers.to_json(include: :answers)
	end
end
