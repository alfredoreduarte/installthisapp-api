module FrontendController

# TODO
# 
# 
# === Feature:
# Ver si hay form y mostrarlo
# 
# === Feature:
# Cuando no haya preguntas cargadas, mostrar una pantalla generica indicando al admin que falta algo. Usar la misma pantalla para todas las apps, en casos donde no se haya cargado algo escencial para la app
#
# === Optimización:
# Este controller sabe demasiado acerca del modelo, al menos en la accion 'save'. Debería pasar los argumentos al model y que este se encargue del resto.
#
#
# 
	
	def jsontest
		respond_to do |format|
			format.json { render "./trivia/views/viewmodel.json" }
		end
	end

	def canvas_entities
		if user_has_pending_questions
			questions = $application.questions
			if @already_answered.length > 0
				questions = questions.where("id not in (#{@already_answered.join(',')})")
			end
			response = {
				status: 'ok',
				settings: {
					time_out: $application.setting.preferences_time_limit,
					application_title: $application.title,
					order: "ASC",
				},
				questions: questions.as_json(include: :options)
			}
		else
			response = {
				status: 'already_answered',
				settings: {},
				questions: [],
			}
		end
		respond_to do |format|
			format.json { render json: response }
		end
	end

	def game_data
		respond_to do |format|
			format.json { render json: app_json }
		end
	end

	def save
		correct_answers = save_params[:correct].to_i
		incorrect_answers = save_params[:incorrect].to_i
		user_summary = $application.user_summaries.find_or_create_by(user_id: $user.id)
		for question in save_params[:details]
			answer = $application.answers.new(
				:correct => question[:correct], 
				:option_id => question[:option],
				:user_id => $user.id,
				:question_id => question[:question],
				:user_summary_id => user_summary.id
			)
			answer.save
			user_summary.total_correct_answers += 1 if question[:correct] == 1 
		end
		user_summary.total_answers = user_summary.total_answers + correct_answers + incorrect_answers
		user_summary.save
		respond_to do |format|
			format.json { render json: user_summary.as_json }
		end
	end
  
	private
  
	def user_has_pending_questions
		@already_answered = []
		entries = $application.answers.where(:user_id => $user.id)
		for entry in entries
			@already_answered << entry.question_id
		end
		if @already_answered.length > 0
			if $application.questions.where("id not in (#{@already_answered.join(',')})").where("active = 1").length > 0
				true
			else
				false
			end
		else
			true
		end   
	end

	def save_params
		params.require(:answers)
	end

	def app_json
		@pal_json = {}
		@pal_json['pages'] = []

		index_page = {}
		index_page['pageName'] = 'index'
		index_page['pageTitle'] = 'Questions'
		index_page['isInitialPage'] = user_has_pending_questions
		index_page['structure'] = {}
		index_page['structure']['components'] = []

		index_page_components = {}
		index_page_components['componentType'] = 'Trivia'
		index_page_components['id'] = 'Trivia4u23iyt'
		index_page_components['children'] = []

		index_page_components['children'][0] = {}
		index_page_components['children'][0]['componentType'] = 'CountDown'
		index_page_components['children'][0]['id'] = 'CountDown4321ur43o'
		index_page_components['children'][0]['props'] = {}
		# index_page_components['children'][0]['props']['initialTime'] = @application.setting.preferences_time_limit
		index_page_components['children'][0]['props']['initialTime'] = 99999

		index_page_components['children'][1] = {}
		index_page_components['children'][1]['componentType'] = 'QuestionSlider'
		index_page_components['children'][1]['id'] = 'QuestionSliderr432432'
		index_page_components['children'][1]['props'] = {}
		index_page_components['children'][1]['props']['order'] = 'random'
		index_page_components['children'][1]['children'] = []

		i = 0
		for question in @application.questions
			index_page_components['children'][1]['children'][i] = {}
			index_page_components['children'][1]['children'][i]['componentType'] = 'Question'
			index_page_components['children'][1]['children'][i]['id'] = question.id
			index_page_components['children'][1]['children'][i]['props'] = {}
			index_page_components['children'][1]['children'][i]['props']['text'] = question.text
			index_page_components['children'][1]['children'][i]['children'] = []
			x = 0
			for option in question.options
				index_page_components['children'][1]['children'][i]['children'][x] = {}
				index_page_components['children'][1]['children'][i]['children'][x]['componentType'] = 'Option'
				index_page_components['children'][1]['children'][i]['children'][x]['id'] = option.id
				index_page_components['children'][1]['children'][i]['children'][x]['props'] = {}
				index_page_components['children'][1]['children'][i]['children'][x]['props']['text'] = option.text
				index_page_components['children'][1]['children'][i]['children'][x]['props']['index'] = option.order_by
				index_page_components['children'][1]['children'][i]['children'][x]['props']['correct'] = option.correct
				x = x + 1
			end
			i = i + 1
		end
		index_page['structure']['components'].push(index_page_components)
		@pal_json['pages'].push(index_page)

		thanks_page = {}
		thanks_page['pageName'] = 'thanks'
		thanks_page['pageTitle'] = 'Thanks for participating'
		thanks_page['structure'] = {}
		thanks_page['structure']['components'] = []
		thanks_page['structure']['components'][0] = {}
		thanks_page['structure']['components'][0]['componentType'] = 'Trivia'
		thanks_page['structure']['components'][0]['id'] = 'Trivia4u23iyfdsaft'
		thanks_page['structure']['components'][0]['children'] = []

		thanks_page['structure']['components'][0]['children'][0] = {}
		thanks_page['structure']['components'][0]['children'][0]['componentType'] = 'Result'
		thanks_page['structure']['components'][0]['children'][0]['id'] = 'Resultfd324432'
		thanks_page['structure']['components'][0]['children'][0]['props'] = {}
		thanks_page['structure']['components'][0]['children'][0]['props']['status'] = 'neutral'
		thanks_page['structure']['components'][0]['children'][0]['props']['text'] = 'That\'s all folks! 🐰 <br/> Thanks for participating.'
		thanks_page['structure']['components'][0]['children'][0]['props']['correct'] = 2
		thanks_page['structure']['components'][0]['children'][0]['props']['incorrect'] = 2
		@pal_json['pages'].push(thanks_page)

		already_played_page = {}
		already_played_page['pageName'] = 'already_played'
		already_played_page['pageTitle'] = 'You\'ve already played'
		already_played_page['isInitialPage'] = !user_has_pending_questions
		already_played_page['structure'] = {}
		already_played_page['structure']['components'] = []
		already_played_page['structure']['components'][0] = {}
		already_played_page['structure']['components'][0]['componentType'] = 'Trivia'
		already_played_page['structure']['components'][0]['id'] = 'Trivia4u24233iyfdsaft'
		already_played_page['structure']['components'][0]['children'] = []

		already_played_page['structure']['components'][0]['children'][0] = {}
		already_played_page['structure']['components'][0]['children'][0]['componentType'] = 'Message'
		already_played_page['structure']['components'][0]['children'][0]['id'] = 'Msg0fds0342'
		already_played_page['structure']['components'][0]['children'][0]['props'] = {}
		already_played_page['structure']['components'][0]['children'][0]['props']['text'] = 'You\'ve already played! ☠️ <br/> Thanks for participating.'
		@pal_json['pages'].push(already_played_page)

		return @pal_json
	end

	def dummy_json
		return  '{
			"pages": [
				{
					"pageName": "you_win",
					"pageTitle": "Great!",
					"structure": {
						"components": [
							{
								"componentType": "Trivia",
								"id": "Trv-2948",
								"props": {
									"coso": "lindo"
								},
								"children": [
									{
										"componentType": "Result",
										"id": "Rult-3421",
										"props": {
											"status": "winner",
											"text": "Well done!",
											"correct": 8,
											"incorrect": 2
										}
									}
								]
							}
						]
					}
				},
				{
					"pageName": "you_lose",
					"pageTitle": "Maybe next time",
					"structure": {
						"components": [
							{
								"componentType": "Trivia",
								"id": "Trv-2948",
								"props": {
									"coso": "lindo"
								},
								"children": [
									{
										"componentType": "Result",
										"id": "Rsut-3421",
										"props": {
											"status": "loser",
											"text": "Maybe next time 😞",
											"correct": 2,
											"incorrect": 8
										}
									}
								]
							}
						]
					}
				},
				{
					"pageName": "already_played",
					"pageTitle": "You\'ve already played",
					"structure": {
						"components": [
							{
								"componentType": "Trivia",
								"id": "Trv-2948",
								"props": {
									"coso": "lindo"
								},
								"children": [
									{
										"componentType": "Message",
										"id": "Msg-3421",
										"props": {
											"text": "Ya participaste!"
										}
									}
								]
							}
						]
					}
				}
			]
		}'
	end
	
end