class PuzzlesEntry < ActiveRecord::Base
	self.table_name = "module_puzzles_entries"
	belongs_to :puzzle, :class_name => "PuzzlesPuzzle"
	belongs_to :user
	belongs_to :application
end