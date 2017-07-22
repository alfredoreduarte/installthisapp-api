json.appTitle @application.title
json.settings @application.setting.conf["preferences"]
json.payload do 
	json.photos do
		json.array! @photos, partial: 'applications/photo', as: :photo
	end
end