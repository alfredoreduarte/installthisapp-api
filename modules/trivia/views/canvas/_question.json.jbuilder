json.extract! question, :id, :text, :application_id, :created_at
json.options do
	json.array! question.options, partial: 'canvas/option', as: :option
end