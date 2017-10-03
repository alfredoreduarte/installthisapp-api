json.entries do
	json.array! @entries, partial: 'applications/entry', as: :entry
end
json.application_log @application_log