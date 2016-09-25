class TriviaQuestion < ActiveRecord::Base
	self.table_name = "module_trivia_questions"
	has_many :options, -> {order('position')}, class_name: "TriviaOption", foreign_key: :question_id, dependent: :destroy
	has_many :answers, :class_name => "TriviaAnswer", :foreign_key => :question_id
	accepts_nested_attributes_for :options, allow_destroy: true
	belongs_to :application
end