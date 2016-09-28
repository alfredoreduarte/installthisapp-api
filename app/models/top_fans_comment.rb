class TopFansComment
	include Mongoid::Document
	include Mongoid::Timestamps
	field :post_id, type: Integer
	field :user_identifier, type: Integer
	field :user_name, type: String
	field :page_id, type: Integer
	field :comment_id, type: Integer

	def self.detail_by_page
		group = {
			'$group': {
				_id: { page_id: '$page_id' },
				commenters: { '$push': { user_name: '$user_name', post_id: '$post_id' } },
				comments: { '$sum': 1 }
			}
		}
		return self.collection.aggregate([group])
	end

	def self.comments_by_page(identifier)
		match = {
			'$match': {
				page_id: identifier.to_i,
			}
		}
		group = {
			'$group': {
				_id: "$user_identifier",
				user_identifier: { "$first": "$user_identifier" },
				user_name: { "$first": "$user_name" },
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
				user_identifier: 1,
				user_name: 1,
			}
		}
		return self.collection.aggregate([match, group, sort, project])
	end
end
