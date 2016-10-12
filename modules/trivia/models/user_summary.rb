class TriviaUserSummary < ActiveRecord::Base
	self.table_name = "module_trivia_user_summaries"
	belongs_to 	:application
	belongs_to 	:fb_users
	has_many 	:answers, :class_name => "TriviaAnswer", :foreign_key => :fb_user_summary_id, :dependent => :destroy
	validates_uniqueness_of :application_id, :scope => :fb_user_id
	before_save(:on => :update) do
		if self.total_answers > 0
			self.qualification = (self.total_correct_answers*100).to_f / self.total_answers
		end
	end
end