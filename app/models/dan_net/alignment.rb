module DanNet
  class Alignment < ActiveRecord::Base
    has_many :syn_sets 
    belongs_to :source
    def synonyms
      self['synonyms'].split("; ").map do |syn|
        syn.gsub("_", " ")
      end
    end
  end
end