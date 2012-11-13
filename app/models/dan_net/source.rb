module DanNet
  class Source < ActiveRecord::Base
    belongs_to :instance
    has_many :alignments, :dependent => :destroy
  end
end
