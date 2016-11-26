require 'resque/tasks'
require 'resque/pool/tasks'

# this task will get called before resque:pool:setup
# and preload the rails environment in the pool manager
task "resque:setup" => :environment do
	# generic worker setup, e.g. Hoptoad for failed jobs
	Resque.before_fork = Proc.new do |job|
		ActiveRecord::Base.connection.disconnect!
	end
	Resque.after_fork = Proc.new do |job|
		ActiveRecord::Base.establish_connection
	end
end

task "resque:pool:setup" do
	# close any sockets or files in pool manager
	# ActiveRecord::Base.connection.disconnect!
	# and re-open them in the resque worker parent
	# Resque::Pool.after_prefork do |job|
		# ActiveRecord::Base.establish_connection
	# end
end