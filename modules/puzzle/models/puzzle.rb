class PuzzlesPuzzle < ActiveRecord::Base
	self.table_name = "module_puzzles_puzzles"
	belongs_to :application
	has_many :entries, :class_name => "PuzzlesEntry", :foreign_key => :puzzle_id, :dependent => :destroy

	has_attached_file :image, 
		styles: { 
			backend: "100x100#",
			frontend: "810x5000>"
		},
		url: '/images/application_photos/puzzle/:id_:basename_:style.:extension',
		path: ':rails_root/public:url'
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
	# validates_presence_of :image, :message => I18n.t(:required_field_error)
	
	# before_create :check_first_active

	# def check_first_active
	# 	puzzles = self.class.select("count(*) as count").where(:application_id => self.application_id)
	# 	if puzzles.count == 0 
	# 		self.active = 1
	# 	end
	# end
	
	# def active_to_human
	# 	case self.active
	# 	when false
	# 		I18n.t(:trivia_inactive_to_human)
	# 	when true
	# 		I18n.t(:trivia_active_to_human)
	# 	end
	# end

	# def set_active
	# 	return false if self.active
	# 	self.class.update_all({:active => 0}, :application_id => self.application_id)
	# 	self.active = 1
	# 	self.save
	# end

	def image_url_backend
		self.image.url(:backend)
	end
end