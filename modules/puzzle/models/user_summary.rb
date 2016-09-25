class PuzzlesUserSummary < ActiveRecord::Base
	self.table_name = "module_puzzles_user_summaries"
	belongs_to :application
	belongs_to :user
	has_many :entries, :class_name => "PuzzlesEntry", :foreign_key => :user_summary_id, :dependent => :destroy
	validates_uniqueness_of :application_id, :scope => :user_id
  	
	before_save(:on => :update) do
		if self.total_entries > 0
			self.average_time = self.total_time/self.total_entries
		end	
	end
		
	def self.test
		"puzzles"
	end

	def test_instance
		"puzzles"
	end
end