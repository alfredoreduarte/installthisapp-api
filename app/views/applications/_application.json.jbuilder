json.extract! application, :id, :title, :checksum, :application_type, :status, :fb_application
json.users do
	json.array! application.fb_users
end
json.page application.fb_page
json.setting application.setting.conf["preferences"]