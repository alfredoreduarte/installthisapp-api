class Setting < ActiveRecord::Base
		
	def defaults
		self.application.template.defaults.merge(
			{
				:preferences => {
					:limit_switch => 'yes',
					:limit => 5,
					:order => 'rand()',
					:time_limit_switch => 'yes',
					:time_limit => 120,
					:show_summary => false
				},
				:design => {
					:chosen_template => :california
				}
			}
		)
	end

	def set_extra_validations
	end
end