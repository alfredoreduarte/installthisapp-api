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
	has_many 		:app_integrations
	has_one 		:setting

	before_create 	:generate_checksum
	before_create 	:create_log
	before_create 	:assign_fb_application
	after_create 	:create_setting

	attr_accessor 	:module_loaded
	attr_accessor 	:facebook_page_loaded

	def self.batch_uninstall_expired_apps
		Application.installed.all.map{ |app| app.uninstall unless app.admin.can(:publish_apps) }
		Application.all.map do |app| 
			unless app.admin.can(:publish_apps)
				app.uninstall_tab
			end
		end
	end

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

	# Creates an application log if it doesn't exist
	def create_log
		ApplicationLog.find_or_create_by(
			checksum: self.checksum,
		)
	end

	def install
		self.installed!
		self.save
		return :ok
	end

	def assign_fb_application
		free_fb_application = FbApplication.find_by(application_type: self.application_type)
		if free_fb_application
			self.fb_application = free_fb_application
		else
			logger.error('Could not obtain a FB Application')
		end
	end

	# 
	# Uninstalling Facebook page tabs
	# 
	# We run the callback first because some apps need the fb_page ID to make certain operations
	# and the delete_tab_on_facebook method breaks that relationship
	# 
	def uninstall_tab
		self.module
		self.uninstall_tab_callback 
		self.delete_tab_on_facebook
	end

	def put_tab_on_facebook(fb_page_identifier)
		fb_page = FbPage.find_by(identifier: fb_page_identifier)
		if fb_page
			# 
			# TODO: remove this association once the canvas TODO is done
			# 
			self.fb_page = fb_page
			pages = FbGraph2::User.me(self.admin.fb_profile.access_token).accounts
			index = pages.find_index{|p| p.id.to_i == fb_page.identifier.to_i}
			unless index.nil?
				if !pages[index].perms.include?("CREATE_CONTENT")
					return :fb_page_not_admin
				end
			else
				return :fb_permission_issue
			end
			
			require "logger"
			user_graph = Koala::Facebook::API.new(self.admin.fb_profile.access_token)
			page_token = user_graph.get_page_access_token(fb_page_identifier)
			conn = Faraday.new(:url => "#{ENV['FB_GRAPH_URL']}/v#{ENV['FB_API_VERSION']}/#{fb_page_identifier}/tabs") do |faraday|
				faraday.request :url_encoded
				faraday.response :logger, ::Logger.new(STDOUT), bodies: true
				faraday.adapter Faraday.default_adapter
				faraday.params['app_id'] = self.fb_application.app_id
				faraday.params['access_token'] = page_token
				faraday.params['custom_name'] = self.title
				faraday.params['position'] = 1
				faraday.params['is_non_connection_landing_tab'] = true
			end
			response = conn.post
			if response.status.to_i == 200
				self.app_integrations.new(integration_type: 0, settings: {
					fb_page_identifier: fb_page.identifier,
					fb_application_identifier: self.fb_application.app_id,
					tab_title: self.title,
				})
				self.installed!
				self.save
				return :ok
			else
				return :error
			end
			return :error
		else
			raise ActiveRecord::RecordNotFound, "No FbPage found for identifier #{fb_page_identifier}"
		end
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
		fb_page = self.get_associated_fb_page
		if self.admin.fb_profile && fb_page
			begin
				user_graph = Koala::Facebook::API.new(self.admin.fb_profile.access_token)
				page_token = user_graph.get_page_access_token(fb_page.identifier)
				koala = Koala::Facebook::API.new(page_token)
				params = {
					tab: 'app_' + self.fb_application.app_id
				}
				# 
				# Remove this only when the association application > fb_page
				# is fully replaced by app_integrations
				# 
				self.fb_page = nil
				# 
				self.save!
				if koala.delete_connections('me', 'tabs', params)
					self.app_integrations.fb_tab.destroy_all
					return true
				else
					return false
				end
			rescue Koala::Facebook::AuthenticationError, Koala::Facebook::ClientError => e
				logger.error(e)
				logger.error("ERROR al eliminar tab de page con ID #{fb_page.id} del admin #{self.admin.id}")
			end
		else
			return false
		end
	end

	def module(_setting_flags={})
		if self.module_loaded.nil?
			self.module_loaded = Modules::Base.load_by_name(self.application_type)
			self.module_loaded.load_associations
			self.save
		end
		return self.module_loaded
	end

	def get_associated_fb_page
		fb_page = nil
		if self.app_integrations.fb_tab
			if self.app_integrations.fb_tab.first
				if self.app_integrations.fb_tab.first.settings["fb_page_identifier"]
					fb_page = FbPage.find_by(identifier: "#{self.app_integrations.fb_tab.first.settings["fb_page_identifier"]}")
				end
			end
		end
		if fb_page == nil
			logger.warn("Had to resort to application.fb_page at get_associated_fb_page")
			fb_page = self.fb_page
		end
		return fb_page
	end

	def stats_summary
		logger.info("/*/*/*/*/*/ STATS SUMMARY: OVERRIDE THIS! /*/*/*/*/*/")
		return {
			stats_summary: []
		}
	end

	def response_for_canvas
		image_dict_assets = self.application_assets.where(attachment_file_name: "images.json")
		return {
			title: self.title,
			checksum: self.checksum,
			fb_application_id: self.fb_application.app_id,
			stylesheet_url: self.application_assets.where(attachment_file_name: "styles.css").last.asset_url,
			messages_url: self.application_assets.where(attachment_file_name: "messages.json").last.asset_url,
			images_url: image_dict_assets.length > 0 ? image_dict_assets.last.asset_url : nil,
			custom_javascript: self.setting.conf["preferences"]["javascript"],
			open_graph_title: self.setting.conf["preferences"]["open_graph_title"],
			open_graph_description: self.setting.conf["preferences"]["open_graph_description"],
			open_graph_image: self.setting.conf["preferences"]["open_graph_image"]
		}
	end

	def response_for_image_dict_assets
		image_dict_assets = self.application_assets.where(attachment_file_name: "images.json")
		if image_dict_assets.length > 0
			return {
				images_url: image_dict_assets.last.asset_url,
			}
		else
			return {
				images_url: nil,
			}
		end
	end

end
