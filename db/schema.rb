# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140226214612) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "applications", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "installer_url"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "installation_url"
    t.string   "base_command"
    t.string   "begin_command"
    t.string   "end_command"
    t.string   "image"
    t.string   "description"
    t.string   "vm_type"
    t.integer  "estimated_time"
  end

  create_table "cloud_files", :force => true do |t|
    t.string   "name"
    t.integer  "directory"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "avatar"
    t.integer  "parent_id"
    t.integer  "directory_id"
    t.integer  "size"
  end

  add_index "cloud_files", ["directory_id"], :name => "index_cloud_files_on_directory_id"
  add_index "cloud_files", ["user_id"], :name => "index_cloud_files_on_user_id"

  create_table "clusters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "instance_type_id"
    t.string   "instance_type"
    t.integer  "user_id"
    t.integer  "execution_id"
  end

  create_table "directories", :force => true do |t|
    t.string   "name"
    t.string   "directory_path"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_id"
    t.integer  "parent_id"
    t.boolean  "is_public"
  end

  add_index "directories", ["parent_id"], :name => "index_directories_on_parent_id"
  add_index "directories", ["user_id"], :name => "index_directories_on_user_id"

  create_table "events", :force => true do |t|
    t.integer  "execution_id"
    t.text     "description"
    t.integer  "code"
    t.datetime "event_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "executions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "application_id"
    t.integer  "directory_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "base_command"
    t.integer  "number_of_jobs"
    t.integer  "computing_hours"
    t.integer  "time_per_job"
    t.integer  "computing_minutes"
    t.integer  "estimated_cost"
    t.decimal  "vm_cost"
    t.integer  "vm_number"
    t.decimal  "total_estimated_cost"
    t.string   "vm_type"
    t.decimal  "estimated_time_minutes"
    t.integer  "cluster_id"
    t.string   "example_command"
    t.string   "queue_name"
    t.integer  "running_jobs"
    t.integer  "finished_jobs"
    t.integer  "current_vms"
    t.boolean  "ended"
    t.decimal  "total_cost"
  end

  create_table "inputs", :force => true do |t|
    t.string   "name"
    t.boolean  "is_file"
    t.boolean  "is_directory"
    t.string   "value"
    t.integer  "cloud_file_id"
    t.integer  "directory_id"
    t.string   "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "application_id"
    t.string   "prefix"
    t.integer  "position"
    t.integer  "execution_id"
    t.boolean  "visible"
    t.boolean  "is_selecteditem"
  end

  create_table "instance_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "jobs", :force => true do |t|
    t.integer  "application_id"
    t.integer  "user_id"
    t.integer  "cluster_id"
    t.integer  "virtual_machine_id"
    t.string   "parameters"
    t.string   "inputs"
    t.string   "status"
    t.date     "start_time"
    t.date     "end_time"
    t.integer  "wallclock_time"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "script_url"
    t.integer  "directory_id"
    t.integer  "execution_id"
  end

  create_table "operating_systems", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "parameters", :force => true do |t|
    t.string   "name"
    t.string   "prefix"
    t.string   "value"
    t.integer  "application_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "selected_items", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "input_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "confirmation_url"
    t.integer  "current_directory_id"
    t.boolean  "approved",               :default => false, :null => false
    t.decimal  "funds"
  end

  add_index "users", ["approved"], :name => "index_users_on_approved"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "virtual_machine_events", :force => true do |t|
    t.string   "action"
    t.integer  "vm_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "virtual_machines", :force => true do |t|
    t.string   "hostname"
    t.integer  "ram"
    t.integer  "cores"
    t.integer  "localStorage"
    t.integer  "clusterId"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "state"
    t.integer  "slots"
    t.string   "AMI_name"
    t.integer  "cluster_id"
    t.boolean  "is_busy"
    t.integer  "execution_hours"
  end

end
