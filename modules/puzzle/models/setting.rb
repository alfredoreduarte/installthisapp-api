class Setting < ActiveRecord::Base
       
	def available_templates
		[
			{
				:file => "pelado",
				:title => "Barebones"
			},
			{
				:file => "california",
				:title => "California"
			}
		]
	end

	def toolbar_options_on_module
		[
			{:file => "layout", :title => I18n.t(:toolbar_preview_layout_screen_title)}
		]
	end
      
	def toolbar_groups_on_module
	[	
		{
 	  		:group_name => :title,
 	  		:tools =>[
 	  			{
 	  				:type => :color_picker,
 	  				:target => :title,
 	  				:attribute => :color
 	  			},
 	  			{
 	  				:type => :font_style,
 	  				:target => :title,
 	  				:attribute => :font_style
 	  			},
 	  			{
 	  				:type => :font_resizer,
 	  				:target => :title,
 	  				:attribute => :size
 	  			},
 	  			{
 	  				:type => :font_family,
 	  				:target => :title,
 	  				:attribute => :font_family
 	  			}
 	  		]
 	  	},
	]
	end
	
	def allowed_user_actions_extras
		{
			:solved =>  {:title => I18.n(:user_actions_answers), :db_column => :custom_action_1}
		}
	end 

	def set_extra_validations
        
   	end
      
	def defaults
		self.application.template.defaults.merge(
			{
				:preferences => {
					:show_summary => false
				},
				:design => {
					:chosen_template => :california
				}
			}
		)
	end
     
end