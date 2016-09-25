class CreateModuleTrivia < ActiveRecord::Migration
	def self.up
		create_table "module_trivia_answers", force: :cascade do |t|
			t.integer  "correct",         limit: 1, default: 0
			t.integer  "option_id",       limit: 4,             null: false
			t.integer  "question_id",     limit: 4,             null: false
			t.integer  "application_id",  limit: 4,             null: false
			t.integer  "user_id",         limit: 4, default: 0
			t.integer  "user_summary_id", limit: 4
			t.datetime "created_on",                            null: false
			t.datetime "updated_on"
		end

		create_table "module_trivia_options", force: :cascade do |t|
			t.string   "text",        limit: 255
			t.boolean  "correct",                 default: true
			t.integer  "question_id", limit: 4,                  null: false
			t.integer  "position",    limit: 4,   default: 0
			t.datetime "created_on",                             null: false
			t.datetime "updated_on"
		end

		create_table "module_trivia_questions", force: :cascade do |t|
			t.string   "text",           limit: 255
			t.integer  "application_id", limit: 4,                  null: false
			t.boolean  "active",                     default: true
			t.datetime "created_on",                                null: false
			t.datetime "updated_on"
		end

		create_table "module_trivia_user_summaries", force: :cascade do |t|
			t.integer  "total_answers",         limit: 4,  default: 0
			t.integer  "total_correct_answers", limit: 4,  default: 0
			t.float    "qualification",         limit: 24, default: 0.0
			t.integer  "application_id",        limit: 4,  default: 0
			t.integer  "user_id",               limit: 4,  default: 0
			t.datetime "created_on",                                     null: false
			t.datetime "updated_on"
		end
	end

	def self.down
		drop_table :module_trivia_answers
		drop_table :module_trivia_options
		drop_table :module_trivia_questions
		drop_table :module_trivia_user_summaries
	end
end
