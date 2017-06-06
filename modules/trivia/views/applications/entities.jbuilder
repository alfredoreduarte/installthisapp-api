json.questions do
	json.array! @questions, partial: 'applications/question', as: :question
end
json.answers do
	json.array! @answers, partial: 'applications/summary', as: :summary
end
json.application_log @application_log