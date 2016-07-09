# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160709215921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contest_tasks", force: :cascade do |t|
    t.integer "contest_id"
    t.integer "task_id"
    t.index ["contest_id", "task_id"], name: "index_contest_tasks_on_contest_id_and_task_id", unique: true, using: :btree
    t.index ["contest_id"], name: "index_contest_tasks_on_contest_id", using: :btree
    t.index ["task_id"], name: "index_contest_tasks_on_task_id", using: :btree
  end

  create_table "contests", force: :cascade do |t|
    t.string  "name"
    t.integer "position"
    t.boolean "active",      default: true
    t.text    "description"
    t.index ["name"], name: "index_contests_on_name", unique: true, using: :btree
    t.index ["position"], name: "index_contests_on_position", unique: true, using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.string   "status",      default: "CH"
    t.datetime "timestamp"
    t.binary   "solution"
    t.integer  "bad_test_id"
    t.string   "bad_out"
    t.index ["task_id"], name: "index_submissions_on_task_id", using: :btree
    t.index ["user_id"], name: "index_submissions_on_user_id", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text   "body"
    t.text   "format"
  end

  create_table "tests", force: :cascade do |t|
    t.integer "task_id"
    t.text    "in"
    t.text    "out"
    t.index ["task_id"], name: "index_tests_on_task_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string  "login"
    t.string  "password"
    t.boolean "admin",    default: false
    t.index ["login"], name: "index_users_on_login", unique: true, using: :btree
  end

  add_foreign_key "contest_tasks", "contests"
  add_foreign_key "contest_tasks", "tasks"
  add_foreign_key "submissions", "tasks"
  add_foreign_key "submissions", "tests", column: "bad_test_id"
  add_foreign_key "submissions", "users"
  add_foreign_key "tests", "tasks"
end
