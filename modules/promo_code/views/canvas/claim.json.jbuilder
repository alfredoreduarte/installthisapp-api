json.success @success
if @success
	json.entries_count @entries_count
end
if !@entry.nil?
	json.partial! 'canvas/entry', entry: @entry
end