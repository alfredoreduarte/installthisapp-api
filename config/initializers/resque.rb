# if ENV["REDISCLOUD_URL"]
	# $redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
# end

Resque.redis = ENV["REDISCLOUD_URL"]