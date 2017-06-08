class ApplicationLog
	Mongoid::QueryCache.enabled = true
	include Mongoid::Document
	include Mongoid::Timestamps

	field :checksum, type: String
	field :design_edited, type: DateTime

	def self.log_by_checksum(checksum)
		match = {
			'$match': {
				checksum: checksum,
			}
		}
		project = {
			'$project': {
				_id: 0,
				design_edited: 1,
				fb_tab_installed: 1,
			}
		}
		result = Mongoid::QueryCache.cache { self.collection.aggregate([match, project]) }
		return result.first
	end

	def self.log_design(checksum, datetime)
		return self.where(checksum: checksum).update(design_edited: datetime)
	end

	def self.log_fb_integration(checksum, datetime)
		return self.where(checksum: checksum).update(fb_tab_installed: datetime)
	end
end
