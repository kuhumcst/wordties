#coding: utf-8
module DanNet
  class PosTag < ActiveRecord::Base
    set_primary_key :id
    has_many :words
  end
end
