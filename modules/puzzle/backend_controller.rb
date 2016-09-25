module BackendController

	# include ApplicationHelper

	def configuration_puzzles
		@setting = @application.setting
	end
	
	def configuration_puzzles_update
		@setting = @application.setting
		
		if @setting.update_attributes(params[:setting])
			render :update do |page|
		    	page.call :flash_message, :info, t(:flash_generic_info_saved_successfully_title), t(:flash_generic_info_saved_successfully)
		    end
		else
		    render :update do |page|
		    	page.call :flash_message, :error, t(:flash_generic_error_updating_title), t(:forms_setting_email_error)
		    end
		end
	end
	
	def module_dashboard_extras
		@total = @application.stats.total
		@today = @application.stats.today
		@top_answers = @application.user_summaries.includes(:user).order('average_time asc, created_on asc').limit(10)
		@latest_answers = @application.user_summaries.includes(:user).order("created_on DESC").limit(10)
	end
	
	def puzzles
		@puzzles = @application.puzzles
	end

	def puzzles_create
		@puzzle = @application.puzzles.create(puzzle_params)
		# broadcast('/puzzle-puzzles/create', @puzzle.as_json(:methods => [:image_url_backend]))
		head :no_content
	end
	
	def puzzles_edit
		@puzzle = @application.puzzles.find(puzzle_params[:id])
		@puzzle.update(puzzle_params)
		# broadcast('/puzzle-puzzles/update', @puzzle.as_json(:methods => [:image_url_backend]))
		head :no_content
	end
	
	def puzzles_destroy
		@puzzle = @application.puzzles.find(params[:id])
		if @puzzle.destroy
			# broadcast('/puzzle-puzzles/destroy', @puzzle)
		end
		head :no_content
	end
	
	def results
		@page_title = t(:answer_list_title)
		
		users_table_setup({
			:sort_table => PuzzlesUserSummary.table_name,
			:default_sort => "created_on DESC"
		})
	    @table_total_entries = @application.user_summaries.includes(:user).where(@table_search_query).count
      	@table_entries = @application.user_summaries.includes(:user, :entries).where(@table_search_query).order(@table_sort).offset(@table_offset).limit(@table_limit)
      	@puzzles = @application.puzzles.order("order_by")

		users_table_render({
			:body => "./results_table_entries", 
			:container => "./results_table", 
			:render_view => "./results"
		})
	end
	
	def entries_delete
		user_summaries = @application.user_summaries.where("user_id in (#{params[:selection_ids]})")
		user_summaries.destroy_all
		render :update do |page|
			page.call :flash_message, :info, t(:pz_entry_delete_flash_info)
			page.call :tableUncheckAll
			page.call :resetSmallWindow, "delete_window"
			page.call :closeModal
			page.call :delete_table_rows, params[:selection_ids].split(",").collect{|id| "#table_row_#{id.strip}"}.join(", ")
		end
	end
	
	def user_results_window
		@user = @application.users.find(params[:user_id])
		@page_title = t(:pz_results_by_user, :user_name => @user.first_name)
		@entries = @user.entries.where("application_id = #{@application.id}").includes(:puzzle).order("created_on ASC")
		@user_summary = @user.user_summaries.first
		render :action => :user_results_window, :layout => "backend/modal"
	end
	
	def export_entries_to_xls
		users_table_setup({
			:sort_table => PuzzlesUserSummary.table_name, 
			:default_sort => "average_time DESC"
		})
		
		title = "#{t(:pz_users_answers)} #{@application.title}"
		case params[:report_type].to_sym
		when :all
		  user_summaries = @application.user_summaries.includes(:user).where(@table_search_query).order(@table_sort)
		when :selection
		  user_summaries = @application.user_summaries.where("user_id in (#{params[:selection_ids]})").includes(:user).order(@table_sort)
		end     
		rows = []
		for us in user_summaries	  
			row = {:identifier => us.user.identifier, :name => us.user.name, :email => us.user.email, :answered_on => us.created_on, :total_entries => "#{us.total_entries}", :average_time => "#{Time.at(us.average_time).utc.strftime("%H:%M:%S")}"}
			if @application.setting.generic_form_enabled == 'yes'
				row.merge!(generic_entries_export_row(us.user.id))
			end
			rows << row
		end
		form_cols, form_cols_name = [], []
		if @application.setting.generic_form_enabled == 'yes'
			form_hash = @application.generic_form.form_to_hash_without_stubs
			unless form_hash.nil?
				form_cols = form_hash.collect{ |k,v| "question_#{k}" }
				form_cols_name = form_hash.collect{ |k,v| v['label'].gsub(",","") }
			end
		end
		cols = ["identifier","name","email","answered_on", "total_entries", "average_time"] + form_cols
		cols_name = translate_cols_for_export(["identifier","name","email","answered_on", "total_entries", "average_time"]) + form_cols_name
		render_to_excel_format(title, rows, cols, cols_name)
	end

	def puzzle_params
		params.require(:puzzles_puzzle).permit(:id, :name, :pieces, :image)
	end

end