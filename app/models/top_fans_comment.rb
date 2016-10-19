class TopFansComment
	include Mongoid::Document
	include Mongoid::Timestamps

	field :created_time, type: Integer
	field :sender_id, type: Integer
	field :post_id, type: String
	field :comment_id, type: String
	field :message, type: String
	field :parent_id, type: String
	field :sender_name, type: String
	field :page_id, type: String

	def self.detail_by_page
		group = {
			'$group': {
				_id: { page_id: '$page_id' },
				commenters: { '$push': { sender_name: '$sender_name', post_id: '$post_id' } },
				comments: { '$sum': 1 }
			}
		}
		return self.collection.aggregate([group])
	end

	def self.comments_by_page(identifier, ignored_ids)
		match = {
			'$match': {
				page_id: identifier.to_s,
				# sender_id: { '$ne': 272699880986 }
				# sender_id: { '$nin': [272699880986, 10209615042475034] }
				sender_id: { '$nin': ignored_ids }
			}
		}
		group = {
			'$group': {
				_id: "$sender_id",
				sender_id: { "$first": "$sender_id" },
				sender_name: { "$first": "$sender_name" },
				comments: {"$sum": 1}
			}
		}
		sort = {
			'$sort': {
				comments: -1,
			}
		}
		project = {
			'$project': {
				_id: 0,
				comments: 1,
				sender_id: 1,
				sender_name: 1,
			}
		}
		return self.collection.aggregate([match, group, sort, project])
	end
end
