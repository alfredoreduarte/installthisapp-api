class Setting < ApplicationRecord
	belongs_to :application
	before_create :init

	private

	def init
		jsonfile = File.open(File.join(Rails.root, 'modules', self.application.application_type.to_s, 'settings.json'))
		conf = JSON.parse(jsonfile.read.to_s)
		self.conf = conf
	end
end
