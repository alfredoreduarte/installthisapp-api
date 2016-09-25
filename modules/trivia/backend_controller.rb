module BackendController

# TODO
#
# === Fix:
# Al crear una nueva pregunta, con una opcion, guardarla, luego editarla y agregar una nueva opcion, la siguiente vez que se abra el form no aparece la ultima opcion creada
#
# === Fix:
# Validar participo/no participo
#
# === Feature:
# Marcar opciones como correctas o no en el backend
#
# === Feature:
# Reordenar preguntas/opciones
#
# === Fix:
# cambiar inicial_time del CountDown por su correspondiente valor configurado en get_trivia_options
#
# === Fix:
# cambiar random del QuestionSlider por su correspondiente valor configurado en get_trivia_options
#
	
	# JSON FOR MODULES
	def jsontest
		respond_to do |format|
			format.json { render "./trivia/views/viewmodelbackend.json" }
		end
	end
	# JSON FOR MODULES

	def module_dashboard_extras
		@top_answers = @application.user_summaries.includes(:user).order("qualification DESC, created_on ASC").limit(10)
		@latest_answers = @application.user_summaries.includes(:user).order("created_on DESC").limit(10)
	end

	def questions
		response = {
			questions: @application.questions.as_json(include: :options),
			answers: @application.user_summaries.as_json(include: :user)
		}
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def questions_create
		hash = params.deep_symbolize_keys
		question = @application.questions.create(hash[:question])
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
		params.require(:question).permit(:id, :text, :active, :application_id, :created_on, :modified_on, options_attributes: [:id, :text, :correct, :position, :question_id, :created_on, :modified_on, :_destroy])
	end

	def answers_json
		@answers = @application.user_summaries.includes(:answers)
		render json: @answers.to_json(include: :answers)
	end
end
