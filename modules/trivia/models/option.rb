class TriviaOption < ActiveRecord::Base
	self.table_name = "module_trivia_options"
	has_many :answers, class_name: "TriviaAnswer", foreign_key: :option_id
	belongs_to :question, class_name: "TriviaQuestion"
end