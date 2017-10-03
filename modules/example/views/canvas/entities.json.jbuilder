json.entries do
	json.array! @entries, partial: 'canvas/entry', as: :entry
end