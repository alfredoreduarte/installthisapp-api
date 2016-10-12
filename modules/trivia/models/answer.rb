class TriviaAnswer < ActiveRecord::Base
	self.table_name = "module_trivia_answers"
	belongs_to :question, :class_name => "TriviaQuestion"
	belongs_to :fb_user
	belongs_to :option, :class_name => "TriviaOption"
	belongs_to :application
	belongs_to :fb_user_summary, :class_name => "TriviaUserSummary", :foreign_key => :answer_id, :dependent => :destroy
end