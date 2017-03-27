json.success @cards.length > 0
json.appTitle @application.title
json.settings @application.setting.conf["preferences"]
json.cards do
	json.array! @cards, partial: 'canvas/card', as: :card
end