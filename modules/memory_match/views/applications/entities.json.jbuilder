json.entries do
	json.array! @entries, partial: 'applications/entry', as: :entry
end
json.cards do
	json.array! @cards, partial: 'applications/card', as: :card
end