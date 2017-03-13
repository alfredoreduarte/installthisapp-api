require 'resque/tasks'

namespace :resque do
	# def del(key)
	# 	Resque.redis.keys(key).each { |k| Resque.redis.del(k) }
	# end

	# desc "Resque setup according to installation guide"
	# task :setup => :environment

	# desc "Reset Resque metadata"
	# task :reset => :environment do
	# 	redis = Resque.redis
	# 	del("worker:*")
	# 	del("stat:processed:*")
	# 	del("delayed:*")
	# 	redis.del("workers")
	# 	redis.set("stat:failed", 0)
	# 	redis.set("stat:processed", 0)
	# end

	# desc "Requeue all Resque failed jobs"
	# task :retry_all => :environment do
	# 	Resque::Failure.count.times do |i|
	# 		Resque::Failure.requeue(i)
	# 	end
	# end

	# desc "Requeue Resque failed jobs that have not been retried yet"
	# task :retry => :environment do
	# 	# retry all failed Resque jobs except the ones that have already been retried
	# 	# This is, for instance, useful if you have already retried some jobs via the web interface.
	# 	Resque::Failure.count.times do |i|
	# 		Resque::Failure.requeue(i) unless Resque::Failure.all(i, 1)['retried_at'].present?
	# 	end
	# end
	
	# desc "Requeue Resque failed jobs that have not been retried yet and remove from failed job queue"
	# task :retry_and_remove => :environment do
	# 	# retry all failed Resque jobs except the ones that have already been retried and then remove from queue
	# 	# Note: if job fails again, it will be re-added to the failed queue as a new failure
	# 	Resque::Failure.count.times do |i|
	# 		next if Resque::Failure.all(i, 1)['retried_at'].present? || !Resque::Failure.all(i, 1)
	# 		Resque::Failure.requeue(i)
	# 		Resque::Failure.remove(i)
	# 	end
	# end

	# desc "Remove Resque failed jobs that have already been retried"
	# task :remove_retried => :environment do
	# 	Resque::Failure.count.times do |i|
	# 		Resque::Failure.remove(i) if Resque::Failure.all(i, 1)['retried_at'].present?
	# 	end
	# end

	# desc "Kill all zombie workers running longer than X seconds"
	# task :kill_zombies => :environment do
	# 	kill_time = ENV['kill_time'] || 300
	# 	Resque.workers.each {|w| w.unregister_worker if w.processing['run_at'] && Time.now - w.processing['run_at'].to_time > kill_time}
	# end
	
	# desc "Unregister all workers for cleanup purposes - requires 'Heroku restart' afterwards"
	# task :unregister_workers => :environment do
	# 	Resque.workers.each {|w| w.unregister_worker}
	# end

	# Alf's custom tasks
	desc "Unregister all non-working workers for cleanup purposes"
	task :cleanup_idle_workers => :environment do
		Resque.workers.each do |worker|
			if worker.working?
				Rails.logger.info(worker.inspect)
			else
				worker.unregister_worker
			end
		end
	end

	desc "Close workers stuck for more than 1 hour"
	task :cleanup_stuck_workers => :environment do
		# allocated_time = 60 * 30
		allocated_time = 60 * 5
		Resque::Worker.working.each do |worker|
			if (worker.started <=> Time.now - allocated_time) < 1
				worker.done_working
				# Rails.logger.info(worker.inspect)
			end
		end
	end
end