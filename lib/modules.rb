module Modules
	class Base
		class << self
			def reload!
				load_applications
			end
			# 
			# Call this inside config/application.rb like this `Modules::Base.initialize!`
			# Loads all modules declared inside config/modules.yml
			# 
			def initialize!
				unless @modules_config = YAML::load(File.open(Rails.root.join('config', 'modules.yml'))) rescue false
					$stderr.puts %Q(This app requires a valid modules config file. Please check `modules.yml` in the config folder.)
					exit 1
				end
				load_applications
				return true
			end
			def load_applications
				@applications = []
				@modules_config.each do |app|
					@applications << ApplicationDefinition.new(app)
				end
			end
			def find_by_name(name)
				@applications.each do |app|
					return app if app.name.to_s == name.to_s
				end
				return nil
			end
			def get_all
				return @applications
			end
			def load_by_name(name)
				find_by_name(name).init!
			end
		end
	end
	 
	class ApplicationDefinition
		
		attr_reader :name
		attr_reader :loaded_models
		attr_accessor :platform
		
		def initialize( attrs )
			@attrs = attrs
			@name = @attrs[0].to_sym
			@loaded_models = []
		end
		
		def method_missing( sym, *args, &block )    
			super unless ret = @attrs[1][sym.to_s] rescue false
			ret
		end
		
		def init!
			self.load_models
			load Rails.root.join('modules', @name.to_s, 'backend_controller.rb')
			load Rails.root.join('modules', @name.to_s, 'frontend_controller.rb')
			return self
		end

		def load_models
			models = Dir[Rails.root.join('modules', @name.to_s, 'models', 'application.rb').to_s]
			models.each {|file|                             
				load(file)
			}
		end

		def unload_models!
			@loaded_models.each {|model| Object.send(:remove_const, model)}
			@loaded_models = []
			true
		end
		
		# NO BORRAR - ejemplo de como traer una vista de módulo
		# def sidebar_options_path
		# 	File.join(@name.to_s, 'views', 'backend', 'sidebar_options').to_s
		# end
		
		def dispatch!(base, from, app)
			case from
				when :backend
					controller_name = BackendController
					base.prepend_view_path(Rails.root.join('modules', @name.to_s, 'views'))
				when :frontend
					controller_name = FrontendController
					base.prepend_view_path(Rails.root.join('modules', @name.to_s, 'views'))  
			end
			base.extend(controller_name)
		end
		
		def load_associations
			unless (@attrs[1]["associations"].blank? rescue true)
				i=0
				loop do
					assocs = (@attrs[1]["associations"][i].split(" ") rescue false)
					break unless assocs
					eval ("#{assocs[0]}.send :#{assocs[1]}, :#{assocs[2]}" + (assocs[3].nil? ? "" : ", :class_name => '#{assocs[3]}'"))
					i+=1
				end
			end
			return true		 
		end
		
	end
		
	module BaseController
		
		def method_for_action(action_name)
			Modules::Base.reload!
			action_name
		end
		
	end
	
end
