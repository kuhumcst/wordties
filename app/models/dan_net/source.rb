module DanNet
  class Source < ActiveRecord::Base
    set_primary_key :source_id
    belongs_to :instance
  end
end