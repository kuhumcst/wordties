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

ActiveRecord::Schema.define(:version => 20120611152012) do

  create_table "alignments", :force => true do |t|
    t.text    "source_id",          :null => false
    t.text    "lemma",              :null => false
    t.text    "definition",         :null => false
    t.text    "synonyms",           :null => false
    t.text    "key",                :null => false
    t.integer "syn_set_id",         :null => false
    t.text    "relation_type_name", :null => false
    t.string  "through_source"
    t.integer "ext_syn_set_id"
  end

  add_index "alignments", ["source_id", "key", "syn_set_id", "relation_type_name", "ext_syn_set_id"], :name => "alignments_source_and_key_and_syn_set_id_uniq", :unique => true

  create_table "ddo_mappings", :force => true do |t|
    t.integer "ddo_id",        :limit => 8, :null => false
    t.integer "word_sense_id", :limit => 8, :null => false
  end

  add_index "ddo_mappings", ["ddo_id", "word_sense_id"], :name => "dn_ddo_mappings_ddo_id_and_word_sense_id_uniq", :unique => true

  create_table "feature_types", :force => true do |t|
    t.text "name", :null => false
  end

  add_index "feature_types", ["id"], :name => "dn_feature_types_id_key", :unique => true

  create_table "features", :force => true do |t|
    t.integer "syn_set_id",      :limit => 8, :null => false
    t.integer "feature_type_id",              :null => false
  end

  add_index "features", ["syn_set_id"], :name => "dn_features_syn_set_id_key"

  create_table "instances", :force => true do |t|
    t.string   "uri"
    t.datetime "last_uptime"
  end

  create_table "pos_tags", :id => false, :force => true do |t|
    t.integer "id",   :null => false
    t.text    "name", :null => false
  end

  add_index "pos_tags", ["id"], :name => "dn_pos_tags_id_key", :unique => true

  create_table "relation_types", :force => true do |t|
    t.text    "name",          :null => false
    t.text    "word_net_name", :null => false
    t.integer "reverse_id"
  end

  add_index "relation_types", ["id"], :name => "dn_relation_types_id_key", :unique => true
  add_index "relation_types", ["reverse_id"], :name => "dn_relation_types_reverse_id_key", :unique => true

  create_table "relations", :force => true do |t|
    t.integer "relation_type_id",                 :null => false
    t.text    "target_word_net_id"
    t.integer "syn_set_id",          :limit => 8, :null => false
    t.boolean "taxonomic"
    t.text    "inheritance_comment"
    t.integer "target_syn_set_id",   :limit => 8
  end

  add_index "relations", ["syn_set_id", "relation_type_id"], :name => "dn_relations_syn_set_id_and_relation_type_id"

  create_table "sources", :id => false, :force => true do |t|
    t.string  "source_id",   :null => false
    t.integer "instance_id"
    t.string  "lang"
  end

  create_table "syn_sets", :id => false, :force => true do |t|
    t.integer "id",            :limit => 8, :null => false
    t.text    "label",                      :null => false
    t.text    "gloss"
    t.text    "usage"
    t.integer "hyponym_count"
  end

  add_index "syn_sets", ["id"], :name => "dn_syn_sets_id_key", :unique => true

  create_table "word_parts", :id => false, :force => true do |t|
    t.integer "word_id",         :limit => 8, :null => false
    t.integer "part_of_word_id", :limit => 8, :null => false
  end

  create_table "word_senses", :force => true do |t|
    t.integer "word_id",         :limit => 8, :null => false
    t.integer "syn_set_id",      :limit => 8, :null => false
    t.text    "register",                     :null => false
    t.text    "heading"
    t.boolean "label_candidate"
  end

  add_index "word_senses", ["heading"], :name => "dn_word_senses_heading_uniq", :unique => true
  add_index "word_senses", ["syn_set_id"], :name => "dn_word_senses_syn_set_id"
  add_index "word_senses", ["word_id"], :name => "dn_word_senses_word_id_key"

  create_table "words", :id => false, :force => true do |t|
    t.integer "id",         :limit => 8, :null => false
    t.text    "lemma",                   :null => false
    t.integer "pos_tag_id",              :null => false
  end

  add_index "words", ["id"], :name => "dn_words_id_key", :unique => true
  add_index "words", ["lemma"], :name => "dn_words_lemma_key"

end
