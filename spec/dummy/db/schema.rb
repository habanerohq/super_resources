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

ActiveRecord::Schema.define(:version => 20130117225232) do

  create_table "child_resources", :force => true do |t|
    t.integer "parent_id"
    t.text    "description"
  end

  create_table "grandparent_resources", :force => true do |t|
    t.integer "parent_id"
    t.text    "description"
  end

  create_table "great_grandparent_resources", :force => true do |t|
    t.text "description"
  end

  create_table "parent_resources", :force => true do |t|
    t.integer "parent_id"
    t.text    "description"
  end

  create_table "simple_resources", :force => true do |t|
    t.string "type"
    t.text   "description"
  end

end
