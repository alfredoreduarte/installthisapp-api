class Application < ApplicationRecord
	enum status: { ready: 0, installed: 1, uninstalled: 2, deleted: 3 }
	belongs_to		:admin
	belongs_to  	:fb_application, optional: true
	# Optional true para poder tener apps no asociadas a fb_page alguno
	belongs_to 		:fb_page, optional: true
	has_many 		:access_tokens
	has_many 		:application_assets
	# has_many 		:users, :through => :access_tokens
	has_many 		:fb_users, :through => :access_tokens
	has_one 		:setting

	before_create 	:generate_checksum
	before_create 	:assign_fb_application
	after_create 	:create_setting

	attr_accessor 	:module_loaded
	attr_accessor 	:facebook_page_loaded

	def generate_checksum
		code = nil
		charset = %w{1 2 3 4 5 6 7 8 9 0 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
		loop do
			code = (0...6).map{ charset.to_a[rand(charset.size)] }.join
			break if Application::find_by_checksum(code).nil?
		end
		self.checksum = code
	end

	def create_setting
		if self.setting.nil?
			self.setting = Setting.new
			self.setting.save
			return true
		else
			return false
		end
	end

	def install
		self.assign_fb_application
		self.installed!
		self.save
		return :ok
	end

	def assign_fb_application
		free_fb_application = FbApplication.find_by(application_type: self.application_type)
		if free_fb_application
			self.fb_application = free_fb_application
			# self.save
		else
			logger.info('Could not obtain a FB Application')
		end
	end

	def put_tab_on_facebook(fb_page_identifier)
		# fb_page = FbPage.find(self.fb_page_id)
		self.assign_fb_application
		fb_page = FbPage.find_by(identifier: fb_page_identifier)
		self.fb_page = fb_page
		# installed_apps = Application.installed.where("fb_page_id = '#{fb_page.id}' and application_type = '#{self.application_type}'")
		# if installed_apps.length > 0
			# free_fb_application = FbApplication::where("id not in (#{installed_apps.collect{|o| o.fb_application_id}.join(",")}) and application_type = '#{self.application_type}'").first
		# else
			# free_fb_application = FbApplication::where("application_type='#{self.application_type}'").first
		# end
		# self.fb_application = free_fb_application
		pages = FbGraph2::User.me(self.admin.fb_profile.access_token).accounts
		index = pages.find_index{|p| p.id.to_i == fb_page.identifier.to_i}
		unless index.nil?
			if !pages[index].perms.include?("CREATE_CONTENT")
				return :fb_page_not_admin
			end
		else
			return :fb_permission_issue
		end

		# 
		# Alt
		# 
		# Make the request using Faraday directly:
		# 
		# require "logger"
		# conn = Faraday.new(:url => "#{ENV['FB_GRAPH_URL']}/v2.9/#{fb_page_identifier}/tabs/") do |faraday|
		# 	faraday.request :url_encoded
		# 	faraday.response :logger, ::Logger.new(STDOUT), bodies: true
		# 	faraday.adapter Faraday.default_adapter
		# 	faraday.params['app_id'] = self.fb_application.app_id
		# 	faraday.params['access_token'] = page_token
		# end
		# response = conn.post
		# logger.info(response.body)
		# !Alt
		user_graph = Koala::Facebook::API.new(self.admin.fb_profile.access_token)
		# graph_fb_p = self.graph_facebook_page(fb_page_identifier)
		page_token = user_graph.get_page_access_token(fb_page_identifier)
		koala = Koala::Facebook::API.new(page_token)
		params = {
			app_id: self.fb_application.app_id,
			# position: 1,
			custom_name: self.title,
		}
		koala.put_connections("me", "tabs", params)
		self.installed!
		self.save!
		return :ok
	end

	def uninstall
		if self.installed?
			self.uninstalled! 
			if self.save!
				return :ok
			else
				return :error
			end
		else
			return :error_was_not_installed
		end
	end

	def delete_tab_on_facebook
		user_graph = Koala::Facebook::API.new(self.admin.fb_profile.access_token)
		logger.info('deleting')
		logger.info(user_graph)
		# page_token = user_graph.get_page_access_token(self.graph_facebook_page.identifier)
		page_token = user_graph.get_page_access_token(self.fb_page.identifier)
		logger.info(page_token)
		koala = Koala::Facebook::API.new(page_token)
		params = {
			tab: 'app_' + self.fb_application.app_id
		}
		self.fb_page = nil
		self.uninstalled!
		self.save!
		if koala.delete_connections('me', 'tabs', params)
			return true
		else
			return false
		end
	end

	def graph_facebook_page(fb_page_identifier)
		# fb_page = FbPage.find(self.fb_page_id)
		fb_page = FbPage.find_by(identifier: fb_page_identifier)
		facebook_page_loaded = FbGraph2::Page.new(fb_page.identifier).fetch(:access_token => self.admin.fb_profile.access_token, :fields => :access_token)
		return facebook_page_loaded
	end

	def module(_setting_flags={})
		if self.module_loaded.nil?
			self.module_loaded = Modules::Base.load_by_name(self.application_type)
			self.module_loaded.load_associations
			self.save
		end
		return self.module_loaded
	end

	def stats_summary
		logger.info("/*/*/*/*/*/ STATS SUMMARY: OVERRIDE THIS! /*/*/*/*/*/")
		return {
			stats_summary: []
		}
	end
end
