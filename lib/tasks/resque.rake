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

	# 
	# Alfredos's custom tasks
	# run them like this:
	# heroku run rake:resque task_name -r production
	# 
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

	desc "Fix old top fans apps without app_integrations objects"
	task :add_integration_definition_to_old_top_fans => :environment do
		all_top_fans = Application.where(status: 1, application_type: 'top_fans').all
		if all_top_fans.length > 0
			all_top_fans.each do |application|
				if application.app_integrations.count == 0
					fb_page_id = application.fb_page_id
					if fb_page_id
						fb_page = FbPage.find(fb_page_id)
						application.app_integrations.create(integration_type: 1, settings: {
							fb_page_identifier: fb_page.identifier,
						})
					end
				end
			end
		end
	end

	task seed_staging: :environment do
		FbApplication.create!([
			{
				name: "Trivia", 
				app_id: "966872033362481",
				secret_key: "5bb5767812f1c7ff8ffaf065d2c3f54b", 
				application_type: "trivia", 
				canvas_id: "app1", 
				namespace: "ita_staging_i",
			},
			{
				name: "Top Fans", 
				app_id: "1064994573589524",
				secret_key: "1658d0a2c742ba7ed94f1f55741f89a5", 
				application_type: "top_fans", 
				canvas_id: "app2", 
				namespace: "ita_staging_ii",
			},
			{
				name: "Photo Contest", 
				app_id: "199928490498786",
				secret_key: "1ed7900133c7307ad0bfce392f85b8f0", 
				application_type: "photo_contest", 
				canvas_id: "app3", 
				namespace: "ita_staging_iii",
			},
			{
				name: "Memory Match", 
				app_id: "1280529118669559",
				secret_key: "d677cc5ae503bb2146aa128e3705c25c", 
				application_type: "memory_match", 
				canvas_id: "app4", 
				namespace: "ita_staging_iv",
			},
			{
				name: "Catalog", 
				app_id: "1613262845358655",
				secret_key: "9d80bb0b2d353b8eac30e1903203dcf0", 
				application_type: "catalog", 
				canvas_id: "app5", 
				namespace: "ita_staging_v",
			},
		])
	end
end