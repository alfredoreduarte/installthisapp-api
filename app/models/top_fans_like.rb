class TopFansLike
	include Mongoid::Document
	include Mongoid::Timestamps

	field :sender_id, type: Integer
	field :sender_name, type: String
	field :post_id, type: String
	field :parent_id, type: String
	field :page_id, type: String
	field :created_time, type: DateTime

	def self.detail_by_page_and_sender(page_id, sender_id)
		Mongoid::QueryCache.enabled = true
		match = {
			'$match': {
				page_id: { '$eq': page_id },
				sender_id: { '$eq': sender_id.to_i },
			}
		}
		group = {
			'$group': {
				_id: { sender_id: '$sender_id', sender_name: '$sender_name' },
				# Using created_at instead of facebook's created_time because that value is 
				# empty at times when we manually parse the page's timeline
				likes: { '$push': { post_id: '$post_id', parent_id: '$parent_id', created_time: '$created_at' } }, 
			}
		}
		Rails.cache.fetch([page_id, sender_id], :expires => 10.minutes) do
			# Need to find a way to return an empty array instead of null here
			# Mongoid::QueryCache.cache { self.collection.aggregate([match, group]) }.to_a || []
			Mongoid::QueryCache.cache { self.collection.aggregate([match, group]) }.to_a
		end
	end

	def self.detail_by_page
		Mongoid::QueryCache.enabled = true
		group = {
			'$group': {
				_id: { page_id: '$page_id' },
				likers: { '$push': { sender_name: '$sender_name', post_id: '$post_id' } },
				likes: { '$sum': 1 }
			}
		}
		return self.collection.aggregate([group])
	end
	
	def self.likes_by_page(identifier, ignored_ids = [], query_limit = 500)
		Mongoid::QueryCache.enabled = true
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
				# createdTime: { "$last": "$created_time" },
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
				# createdTime: 1,
				senderId: 1,
				senderName: 1,
			}
		}
		# result = Mongoid::QueryCache.cache { self.collection.aggregate([match, group, sort, project]) }
		# return result
		# Rails.cache.fetch(identifier, :expires => 10.minutes) do
			Mongoid::QueryCache.cache { self.collection.aggregate([match, group, sort, project]) }.to_a
		# end
	end

	def self.detail_by_page_and_user(page_identifier, user_identifier)
		Mongoid::QueryCache.enabled = true
		match = {
			'$match': {
				page_id: page_identifier,
				sender_id: user_identifier.to_i,
			}
		}
		group = {
			'$group': {
				_id: "$sender_id",
				senderId: { "$first": "$sender_id" },
				senderName: { "$first": "$sender_name" },
				likes: {"$sum": 1}
			}
		}
		project = {
			'$project': {
				_id: 0,
				likes: 1,
				senderId: 1,
				senderName: 1,
			}
		}
		# result = Mongoid::QueryCache.cache { self.collection.aggregate([match, group, project]) }
		# return result
		Rails.cache.fetch([page_identifier, user_identifier], :expires => 10.minutes) do
			Mongoid::QueryCache.cache { self.collection.aggregate([match, group, project]) }.to_a
		end
	end
end
