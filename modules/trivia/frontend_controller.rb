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
	
	def entities
		already_answered = []
		entries = @application.answers.where(fb_user_id: @fb_user.id)
		for entry in entries
			already_answered << entry.question_id
		end
		if already_answered.length > 0
			if @application.questions.where("id not in (#{already_answered.join(',')})").where("active = true").length > 0
				@questions = @application.questions.where("id not in (#{already_answered.join(',')})")
			else
				@questions = []
			end
		else
			@questions = @application.questions
		end
	end

	def save
		correct_answers = save_params[:correct].to_i
		incorrect_answers = save_params[:incorrect].to_i
		user_summary = @application.user_summaries.find_or_create_by(fb_user_id: @fb_user.id)
		for question in save_params[:details]
			answer = @application.answers.new(
				:correct => question[:correct], 
				:option_id => question[:option] || -1,
				:fb_user_id => @fb_user.id,
				:question_id => question[:question],
				:fb_user_summary_id => user_summary.id
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
		entries = @application.answers.where(:fb_user_id => @fb_user.id)
		for entry in entries
			@already_answered << entry.question_id
		end
		if @already_answered.length > 0
			if @application.questions.where("id not in (#{@already_answered.join(',')})").where("active = 1").length > 0
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
	
end