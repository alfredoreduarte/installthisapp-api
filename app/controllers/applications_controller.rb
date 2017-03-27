class ApplicationsController < ApplicationController
	before_action :authenticate_admin!, except: [:index]
	require 'fileutils'
	include Modules::BaseController
	before_action :get_application, :except => [:index, :create]
	before_action :load_module, :except => [:index, :create]
	before_action :dispatch_module, :except => [
		:destroy,
	]

	def index
		render json: {
			apps: Application.installed.as_json,
		}
	end
	def styles
		response = {
			stylesheet_url: @application.application_assets.where(attachment_file_name: "styles.css").last.asset_url,
		}
		render json: response
	end
	def messages
		response = {
			messages_url: @application.application_assets.where(attachment_file_name: "messages.json").last.asset_url,
		}
		render json: response
	end
	def images
		image_dict_assets = @application.application_assets.where(attachment_file_name: "images.json")
		if image_dict_assets.length > 0
			response = {
				images_url: image_dict_assets.last.asset_url,
				# images_url: '...',
			}
		else
			response = {
				images_url: nil,
			}
		end
		render json: response
	end
	def stats_summary
		render json: @application.stats_summary
	end

	def create
		@application = current_admin.applications.new(application_params)
		if current_admin.can(:create_apps) || @application.application_type == 'trivia'
			if (@application.save!)
				load_module
				generate_css(params[:initial_styles])
				generate_messages(params[:initial_messages_json])
				generate_images(params[:initial_images_json])
				@success = true
				render 'applications/create'
			else
				render json: {
					success: false,
					message: "Failed to save instantiated application"
				}
			end
		else
			render json: {
				success: false,
				message: "User can't create apps"
			}
		end
	end

	def update
		@application.update_attributes(application_params)
		render partial: 'applications/application', locals: {application: @application}
	end

	def update_setting
		@application.setting.conf["preferences"] = params[:setting]
		@application.setting.save!
		render partial: 'applications/application', locals: {application: @application}
	end

	def install
		if current_admin.can(:publish_apps)
			install_result = @application.install
			if install_result == :ok
				@application.install_callback
				render json: @application.as_json(include: [:fb_users, :fb_application])
			else
				render json: { status: install_result }
			end
		else
			render json: {
				success: false,
				message: "User can't publish apps"
			}
		end
	end
	def install_tab
		@application.put_tab_on_facebook(params[:fb_page_identifier])
		@application.install_tab_callback
		@admin = current_admin
		render 'admins/entities'
	end
	def uninstall_tab
		@application.delete_tab_on_facebook
		@application.uninstall_tab_callback
		@admin = current_admin
		render 'admins/entities'
	end
	def uninstall
		uninstall_result = @application.uninstall
		if uninstall_result == :ok
			@application.uninstall_callback
			render json: @application.as_json(include: [:fb_users, :fb_application])
		else
			render json: { status: uninstall_result }
		end
	end
	def destroy
		@application.deleted!
		@application.save
		render json: @application.as_json
	end
	def save_app_from_editor
		generate_css(params[:css])
		generate_messages(params[:messages])
		generate_images(params[:images])
		render json: @response
	end


	private

	def application_params
		params.require(:application).permit(:fb_page_id, :application_type, :title, :tracking_code, :timezone, :app_availability, :country_restriction, :timezone)
	end

	def get_application
		checksum = params[:checksum] || params[:id]
		if current_admin.email == 'alfredoreduarte@gmail.com'
			@application = Application.find_by(checksum: checksum)
		else
			@application = current_admin.applications.find_by(checksum: checksum)
		end
	end

	def asset_params
		params.require(:asset).permit(:id, :attachment)
	end

	def load_module
		@module = @application.module
	end

	def dispatch_module
		unless @module.nil?
			@module.dispatch!(self, :backend, @application)
		end
	end

	# 
	# CSS
	# 
	def generate_css(content)
		@application.application_assets.where(attachment_file_name: 'styles.css').all.map{|asset| asset.destroy}
		path = "#{Rails.root}/app/assets/stylesheets/application_stylesheets/#{@application.checksum}/"
		FileUtils.mkdir_p(path) unless File.directory?(path)
		css_file = path + "styles.css"
		File.open(css_file, "w+") do |f|
			f.write(content)
		end
		upload_css_to_s3(css_file)
	end
	def upload_css_to_s3(css_file)
		asset = @application.application_assets.new
		asset.attachment = File.open(css_file)
		asset.attachment_content_type = "text/css"
		asset.save!
		cleanup_local_css_files(css_file)
		return { status: "success", path: asset.as_json(:methods => [:asset_url]) }
	end
	def cleanup_local_css_files(file)
		File.delete(file) if File.exist?(file)
		FileUtils.remove_dir "#{Rails.root}/app/assets/stylesheets/application_stylesheets/#{@application.checksum}", false
	end

	# 
	# STATIC MESSAGES
	# 
	def generate_messages(content)
		@application.application_assets.where(attachment_file_name: 'messages.json').all.map{|asset| asset.destroy}
		path = "#{Rails.root}/app/assets/json/application_messages/#{@application.checksum}/"
		FileUtils.mkdir_p(path) unless File.directory?(path)
		json_file = path + "messages.json"
		File.open(json_file, "w+") do |f|
			f.write(content)
		end
		@response = upload_json_to_s3(json_file)
	end
	def upload_json_to_s3(json_file)
		@asset = @application.application_assets.new
		@asset.attachment = File.open(json_file)
		@asset.attachment_content_type = "application/json"
		@asset.save!
		cleanup_local_json_files(json_file)
		return {status: "success", path: @asset.as_json(:methods => [:asset_url])}
	end
	def cleanup_local_json_files(file)
		File.delete(file) if File.exist?(file)
		FileUtils.remove_dir "#{Rails.root}/app/assets/json/application_messages/#{@application.checksum}", false
	end

	# 
	# STATIC IMAGES
	# 
	def generate_images(content)
		@application.application_assets.where(attachment_file_name: 'images.json').all.map{|asset| asset.destroy}
		path = "#{Rails.root}/app/assets/json/application_images/#{@application.checksum}/"
		FileUtils.mkdir_p(path) unless File.directory?(path)
		json_file = path + "images.json"
		File.open(json_file, "w+") do |f|
			f.write(content)
		end
		@response = upload_images_json_to_s3(json_file)
	end
	def upload_images_json_to_s3(json_file)
		@asset = @application.application_assets.new
		@asset.attachment = File.open(json_file)
		@asset.attachment_content_type = "application/json"
		@asset.save!
		cleanup_local_images_json_files(json_file)
		return {status: "success", path: @asset.as_json(:methods => [:asset_url])}
	end
	def cleanup_local_images_json_files(file)
		File.delete(file) if File.exist?(file)
		FileUtils.remove_dir "#{Rails.root}/app/assets/json/application_images/#{@application.checksum}", false
	end
end
