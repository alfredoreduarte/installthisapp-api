json.success @success
json.entries do
	json.array! @entries, partial: 'canvas/entry', as: :entry
end
json.time_left @time_left