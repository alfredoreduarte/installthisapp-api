class Setting < ActiveRecord::Base
		
	def defaults
		self.application.template.defaults.merge(
			{
				:preferences => {
					:vote_many_times => 'yes'
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