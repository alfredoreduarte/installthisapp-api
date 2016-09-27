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
end
