json.entries do
	json.array! @entries, partial: 'applications/entry', as: :entry
end