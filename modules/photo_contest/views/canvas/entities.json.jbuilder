json.success @success
json.appTitle @application.title
json.settings @application.setting.conf["preferences"]
json.photos do
	json.array! @photos, partial: 'applications/photo', as: :photo
end