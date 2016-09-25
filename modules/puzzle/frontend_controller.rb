module FrontendController

	def index
		@authorized = {:play => @access_token.have_perms?(@fb_application.get_secondary_perms(:play))}	
		if generic_form?(:before)
			logger.info("/-/-/-/-/ GENERIC FORM BEFORE /-/-/-/-/")
			logger.info("/-/-/-/-/ redirect_to #{url_for(:controller => :canvas, :action => :generic_form, :callback => "index")} /-/-/-/-/")
			redirect_to :controller => :canvas, :action => :generic_form, :callback => "index"
		else
			logger.info("/-/-/-/-/ USER ON INDEX: #{@user.inspect} - APPID: #{@application.id} /-/-/-/-/")
			logger.info("/-/-/-/-/ SESSION: #{session[@application.checksum].inspect} /-/-/-/-/")
			puzzles = check_if_already_played
			if @application.puzzles.where("active = 1").length > 0
				if puzzles.length == 0
					redirect_to(:action => :already_played)
				else
					@puzzle = puzzles.first
					unless @puzzle.image.frontend.url.nil?
						@puzzle_url = @puzzle.image.frontend.url
					else
						@puzzle_url = @puzzle.image.url
					end
					if @puzzle.entries.length > 0
						topten = []
						topentries = @puzzle.entries
						for entry in topentries
							topten << entry.user_id
						end
						@topusers = topentries.where("user_id in (#{topten.join(',')})").limit(10).includes(:user).order('time asc') if @application.setting.show_score == "yes"
					end
					session.delete("puzzle_entry_#{@application.checksum}".to_sym)
					#render :action => :index
					#render :template => './index.html.erb'
					if mobile?
						render :template => '/modules/puzzle/views/frontend/mobile/index.html'
					else
						render :template => '/modules/puzzle/views/frontend/index.html'
					end
				end
			else
				redirect_to :action => :no_puzzles
			end
		end
	end
	
	def no_puzzles
		
	end
	
	def solved
		unless session["puzzle_entry_#{@application.checksum}".to_sym].nil?
			prev = session["puzzle_entry_#{@application.checksum}".to_sym]
			params[:entry_data] = prev[:entry_data]
			params[:puzzle_id] = prev[:puzzle_id]
			session.delete("puzzle_entry_#{@application.checksum}".to_sym)
		end
		unless params[:entry_data].nil?
			if generic_form?(:after)
				session["puzzle_entry_#{@application.checksum}".to_sym] = {:entry_data => params[:entry_data], :puzzle_id => params[:puzzle_id]}
				redirect_to :controller => :canvas, :action => :generic_form, :callback => "solved"
			else
				puzzles = check_if_already_played
				if puzzles.length == 0
					redirect_to(:action => :already_played)
				else
					logger.info("/-/-/-/-/ SESSION: #{session[@application.checksum].inspect} - APPID: #{@application.id} /-/-/-/-/")
					logger.info("/-/-/-/-/ USER ON SOLVED: #{@user.inspect} - APPID: #{@application.id} /-/-/-/-/")
					if @user.dummy?
						logger.info("/-/-/-/-/ DUMMY USER DETECTED! - APPID: #{@application.id} /-/-/-/-/")
						flash[:error] = t(:facebook_login_error_title), t(:facebook_login_error_message)
						redirect_to :action => :index
					else
						require 'base64'
						decoded_str = Base64.decode64(params[:entry_data])
						logger.info("/-/-/-/-/ ENTRY DATA: #{decoded_str} - APPID: #{@application.id}/*/*/*/*/")
						decoded_time = decoded_str.split("&")[0].split("=")[1]
						@user_summary = @application.user_summaries.find_or_initialize_by_user_id(@user.id)
						@user_summary.save
						@entry_time = 0;
						entry = @application.entries.where(:user_id => @user.id, :puzzle_id => params[:puzzle_id]).first
						if entry.nil?
							entry = @application.entries.new(:puzzle_id => params[:puzzle_id], :time => decoded_time, :user_id => @user.id, :user_summary_id => @user_summary.id)
							entry.save
							logger.info("/-/-/-/-/ ENTRY CREATED: #{entry.inspect} FOR USER #{entry.user.name rescue 'n/a'} - APPID: #{@application.id} /-/-/-/-/")
							@user_summary.total_time += entry.time
							@entry_time = entry.time
							@best_time = entry.time
						else
							logger.info("/-/-/-/-/ ENTRY GET #{entry.inspect} FOR USER #{entry.user.name rescue 'n/a'} - APPID: #{@application.id} /-/-/-/-/")
							new_time = decoded_time.to_i
							if entry.time.to_i > new_time
								@user_summary.total_time = @user_summary.total_time - entry.time
								entry.time = new_time
								entry.save
								logger.info("/-/-/-/-/ ENTRY UPDATED: #{entry.inspect} FOR USER #{entry.user.name rescue 'n/a'} - APPID: #{@application.id} /-/-/-/-/")
								@entry_time = entry.time
								@best_time = entry.time
								@user_summary.total_time = @user_summary.total_time + entry.time
							else
								@entry_time = new_time
								@best_time = entry.time
							end
							#@user_summary.total_time += entry.time
						end
						@user_summary.total_entries = @application.entries.where(:user_id => @user.id).length
						@user_summary.save
						logger.info("/-/-/-/-/ USER SUMMARY: #{@user_summary.inspect} FOR USER #{entry.user.name rescue 'n/a'} - APPID: #{@application.id} /-/-/-/-/")
						log_user_action(:solved)
						redirect_to :action => :thanks, :puzzle_id => params[:puzzle_id], :time => @entry_time, :best_time => @best_time
					end
				end
			end
		else
			redirect_to :action => :index
		end
	end
	
	def thanks
		logger.info "Started: Puzzle::FrontendController::thanks; time=(#{show_logger_timer}s)"
		logger.info("/-/-/-/-/ SESSION: #{session[@application.checksum].inspect} - APPID: #{@application.id} /-/-/-/-/")
		logger.info("/-/-/-/-/ ENTERING THANKS FOR USER #{@user.inspect rescue 'n/a'} - APPID: #{@application.id} /-/-/-/-/")
		puzzle = @application.puzzles.find(params[:puzzle_id])
		entries = puzzle.entries.order('time asc').limit(10)
		@position = 0
		i = 1
		for entry in entries
			if entry.user_id == @user.id
				@position = i
			end
			i+=1
		end
		@puzzles = check_if_already_played
		@time = Time.at(params[:time].to_i).utc.strftime("%M:%S")
		@best_time = Time.at(params[:best_time].to_i).utc.strftime("%M:%S")
		logger.info "Finished: Puzzle::FrontendController::thanks; Creating OpenGraph hash; time=(#{show_logger_timer}s)"
		og_hash = {:image => "#{request.protocol}#{request.host_with_port}#{puzzle.image.normal.url}", :custom => {"#{@fb_application.namespace}:puzzle_time" => params[:time].to_i}}
		logger.info "Finished: Puzzle::FrontendController::thanks; Calling OpenGraph...; time=(#{show_logger_timer}s)"
		OpenGraph::action(@application, @access_token.token, "solve", "puzzle", og_hash)
		logger.info "Finished: Puzzle::FrontendController::thanks; OpenGraph finished; time=(#{show_logger_timer}s)"
		logger.info "Finished: Puzzle::FrontendController::thanks; time=(#{show_logger_timer}s)"
	end
	
	def already_played
		render :template => './already_played.html.erb'
	end
	
	private
	
	def check_if_already_played
		if @application.setting.play_many_times_value.to_s == "no"
			unless @user.dummy?
				entries = @application.entries.where(:user_id => @user.id)
				solved = []
				for entry in entries
					solved << entry.puzzle_id
				end
				if solved.length > 0
					puzzles = @application.puzzles.where("id not in (#{solved.join(',')})").where("active = 1").order('rand()')
				else
					puzzles = @application.puzzles.where("active = 1").order('rand()')
				end
			else
				puzzles = @application.puzzles.where("active = 1").order('rand()')
			end	
		else
			puzzles = @application.puzzles.where("active = 1").order('rand()')
		end
		return puzzles
	end

end