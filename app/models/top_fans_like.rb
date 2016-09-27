class TopFansLike
	include Mongoid::Document
	include Mongoid::Timestamps
	field :post_id, type: Integer
	field :user_identifier, type: Integer
	field :user_name, type: String
	field :page_id, type: Integer

	def self.detail_by_page
		group = {
			'$group': {
				_id: { page_id: '$page_id' },
				likers: { '$push': { user_name: '$user_name', post_id: '$post_id' } },
				likes: { '$sum': 1 }
			}
		}
		return self.collection.aggregate([group])
	end
	
	def self.likes_by_page(identifier)
		match = {
			'$match': {
				page_id: identifier.to_i,
			}
		}
		group = {
			'$group': {
				_id: {
					"user_identifier": "$user_identifier",
					"user_name": "$user_name",
				},
				likes: {'$sum': 1}
			}
		}
		sort = {
			'$sort': {
				likes: -1,
			}
		}
		return self.collection.aggregate([match, group, sort])
	end
end
