class Setting < ApplicationRecord
	belongs_to :application
	before_create :init

	private

	def init
		jsonfile = File.open(File.join(Rails.root, 'modules', self.application.application_type.to_s, 'settings.json'))
		conf = JSON.parse(jsonfile.read)
		self.conf = conf.to_json
	end
end
