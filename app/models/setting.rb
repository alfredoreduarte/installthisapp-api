class Setting < ApplicationRecord
  belongs_to :application

  attr_accessor 	:conf_tmp, :validations, :tmp_image, :flags
  
	before_validation do
		logger.debug "before_validationnnnn"
		# logger.debug "Aca entro antes que te rompas puto de mierda!!!"
		unless self.validations.nil?   
			Setting._validators = {}
			self.validations.each do |validation|
				# puts "-------#{validation}--------"
				eval(validation)
			end
		end
	end

	#   before_save(:on => :update) do
	before_update do
		logger.debug "before_saveeeeee"
		# logger.info "------------ DELETING CACHES => #{Rails.cache.delete("module_defaults_#{self.application.checksum}")} -------------"
		unless (self.conf.nil? rescue true)
			self.conf_tmp = self.conf
			self.conf.each do |element, attributes|
				attributes.each do |attribute, value|
					el = "#{element}_#{attribute}"
					if attribute == :image
						if self.flags[:upload] == true
							deleted_image = eval("self.#{el}_deleted").to_i
							if deleted_image == 0
								self.conf_tmp[element.to_sym][attribute.to_sym] = (eval("self.#{el}.filename") rescue nil)
							else
								self.conf_tmp[element.to_sym][attribute.to_sym] = nil
							end 
						else
							self.conf_tmp[element.to_sym][attribute.to_sym] = (eval("self.#{el}.filename") rescue nil)  
						end
					else
						self.conf_tmp[element.to_sym][attribute.to_sym] = eval("self.#{el}")
					end
				end
			end
			self.conf = self.conf_tmp
			generate_css_from_sass if self.flags[:upload]
		end
	end
  
	def init(flags={}) # lo del flag es un parche horrible
		logger.info "----------------- SETTING INIT -----------------"
		self.flags = flags
		self.conf_tmp = self.defaults
		self.conf_tmp.each do |element, attributes|   
			attributes.each do |attribute, default_value|
				el = "#{element}_#{attribute}"
				# logger.debug "-------- INIT:#{el} --------------"
				Setting.send :attr_accessor, el.to_sym        
				db_value = (self.conf[element.to_sym][attribute.to_sym] rescue nil)
				if attribute.to_sym == :image
					versions = self.defaults[element.to_sym][attribute.to_sym][:versions]
					# logger.debug "\t-------- INIT:#{el} => VERSIONS #{versions} --------------"
					# versions = {}
					if self.flags[:upload] == true
						Setting.send :image_column, el.to_sym, :versions => versions, :store_dir => proc{|record, file| "application_photos/#{self.application_id}/#{el}/"}   
						Setting.send :attr_accessor, "#{el}_deleted".to_sym             
					else   
						Setting.send :attr_accessor, "#{el}_temp".to_sym
					end  
				end 
				unless db_value.nil?
					if attribute.to_sym == :image
						value = self.get_image_colum(db_value, el.to_sym, versions)
						eval %{self.#{el} = value}  rescue nil # Aca hay un parche horrible!!
					else                   
						eval %{self.#{el} = db_value}
					end                 
				else
					if attribute.to_sym == :image                
						eval %{self.#{el} = nil} rescue nil
					else
						eval %{self.#{el} = default_value} 
					end
				end
			end
		end
		self.conf = self.conf_tmp
		logger.info("*-*-*-* CLEARING VALIDATIONS FOR SETTING MODEL *-*-*-*")
		Setting::reset_callbacks(:validate) # BOOM?
		logger.info("*-*-*-* SETTING NEW VALIDATIONS FOR SETTING MODEL *-*-*-*")
		self.set_validations     
	end  
  
   
	def set_validations
		self.validations = []
		self.conf.each do |element, attributes|
			attributes.each do |attribute, value|
				el = "#{element}_#{attribute}"
				case attribute.to_sym
					when :value
						# self.validations << %{validates_presence_of :#{el}, :message => #{I18n.t(:required_field_error)}}
					when :color || :background_color || :border_color
						self.validations << %{validates_presence_of :#{el}, :message => "#{I18n.t(:required_field_error)}"}
					when :size || :lineheight || :limit
						self.validations << %{validates_numericality_of :#{el}, :message => "#{I18n.t(:numeric_field_error)}"}
						self.validations << %{validates_presence_of :#{el}, :message => "#{I18n.t(:required_field_error)}"}
					when :font_family
						#chan
					when :number_value
						self.validations << %{validates_numericality_of :#{el}, :message => "#{I18n.t(:numeric_field_error)}"}
					when :visibility || :active || :font_style_bold || :font_style_italic || :font_style_underline
						self.validations << %{validates_inclusion_of :#{el}, :in => ["1","0"], :message => "#{I18n.t(:allowed_values_1_and_0_error)}"}
					# when :image
					# self.validations << %{validates_presence_of :#{el}, :message => #{I18n.t(:required_field_error)}}
				end       
			end
		end
		self.set_extra_validations rescue nil
	end

	def get_field(field)
		eval("self.#{field}")
		rescue
			return nil
	end

	def conf
		YAML::load(read_attribute(:conf)) rescue nil
	end

	def conf= (value)
		write_attribute(:conf, value.to_yaml)
	end
   
	def toolbar_options
		if (self.generic_form_enabled.nil? rescue true)
			options = self.application.template.toolbar_options + self.toolbar_options_on_module
		else
			if self.generic_form_enabled == 'yes' && self.generic_form_position == 'before'
				options = self.application.template.toolbar_options + [{:file => "form", :title => I18n.t(:toolbar_preview_generic_form)}] + self.toolbar_options_on_module
			elsif self.generic_form_enabled == 'yes' && self.generic_form_position == 'after'
				options = self.application.template.toolbar_options + self.toolbar_options_on_module + [{:file => "form", :title => I18n.t(:toolbar_preview_generic_form)}]
			else
				options = self.application.template.toolbar_options + self.toolbar_options_on_module
			end 
		end
		return options
	end
   
	def toolbar_groups
		groups = self.application.template.toolbar_groups + self.toolbar_groups_on_module   	  
		return groups
		rescue 
			return false
	end

	def reset_validations
		Setting::reset_callbacks(:validate)
	end
	  
	private
end
