class TopFansLike
	include Mongoid::Document
	include Mongoid::Timestamps

	field :parent_id, type: String
	field :sender_name, type: String
	field :post_id, type: String
	field :page_id, type: String
	field :created_time, type: DateTime
	field :sender_id, type: Integer

	def self.detail_by_page
		group = {
			'$group': {
				_id: { page_id: '$page_id' },
				likers: { '$push': { sender_name: '$sender_name', post_id: '$post_id' } },
				likes: { '$sum': 1 }
			}
		}
		return self.collection.aggregate([group])
	end
	
	def self.likes_by_page(identifier, ignored_ids, query_limit)
		match = {
			'$match': {
				page_id: identifier.to_s,
				sender_id: { '$nin': ignored_ids }
			}
		}
		limit = {
			'$limit': query_limit
		}
		group = {
			'$group': {
				_id: "$sender_id",
				createdTime: { "$last": "$created_time" },
				senderId: { "$first": "$sender_id" },
				senderName: { "$first": "$sender_name" },
				likes: {"$sum": 1}
			}
		}
		sort = {
			'$sort': {
				likes: -1,
			}
		}
		project = {
			'$project': {
				_id: 0,
				likes: 1,
				createdTime: 1,
				senderId: 1,
				senderName: 1,
			}
		}
		return self.collection.aggregate([match, group, sort, project, limit])
	end
end
