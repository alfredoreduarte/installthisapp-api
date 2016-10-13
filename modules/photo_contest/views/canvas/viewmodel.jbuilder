json.appTitle @application.title
json.settings 
json.payload do 
	json.photos do
		json.array! @photos, partial: 'applications/photo', as: :photo
	end
end