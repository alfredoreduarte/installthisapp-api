class CreateModuleTrivia < ActiveRecord::Migration[5.0]
	def up
		create_table "module_trivia_answers" do |t|
			t.integer  "correct",         limit: 1, default: 0
			t.integer  "option_id",       limit: 4,             null: false
			t.integer  "question_id",     limit: 4,             null: false
			t.integer  "application_id",  limit: 4,             null: false
			t.integer  "user_id",         limit: 4, default: 0
			t.integer  "user_summary_id", limit: 4
			t.timestamps
		end

		create_table "module_trivia_options" do |t|
			t.string   "text",        limit: 255
			t.boolean  "correct",                 default: true
			t.integer  "question_id", limit: 4,                  null: false
			t.integer  "position",    limit: 4,   default: 0
			t.timestamps
		end

		create_table "module_trivia_questions" do |t|
			t.string   "text",           limit: 255
			t.integer  "application_id", limit: 4,                  null: false
			t.boolean  "active",                     default: true
			t.timestamps
		end

		create_table "module_trivia_user_summaries", force: :cascade do |t|
			t.integer  "total_answers",         limit: 4,  default: 0
			t.integer  "total_correct_answers", limit: 4,  default: 0
			t.float    "qualification",         limit: 24, default: 0.0
			t.integer  "application_id",        limit: 4,  default: 0
			t.integer  "user_id",               limit: 4,  default: 0
			t.timestamps
		end
	end

	def down
		drop_table :module_trivia_answers
		drop_table :module_trivia_options
		drop_table :module_trivia_questions
		drop_table :module_trivia_user_summaries
	end
end
