json.photos do
	json.array! @photos, partial: 'applications/photo', as: :photo
end
json.application_log @application_log