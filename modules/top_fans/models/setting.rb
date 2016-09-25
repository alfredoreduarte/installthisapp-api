class Setting < ActiveRecord::Base
		
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

	def set_extra_validations
	end
end