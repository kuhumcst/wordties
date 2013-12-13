module DanNet
  class Alignment < ActiveRecord::Base
    has_many :syn_sets 
    belongs_to :source
    
    def synonyms
      self['synonyms'].split("; ").map do |syn|
        syn.gsub("_", " ")
      end
    end

    def self.suggest_lemmas_by_part(part, limit=10)
      case part.length
      when 0
        []
      else
        Alignment.prefix_suggestions(part, limit)
      end
    end

    private
    def self.prefix_suggestions(part, limit)
	sql = %{  SELECT DISTINCT(lemma)
                FROM alignments
                WHERE lemma LIKE ? AND source_id = 'wordnet30'
                ORDER BY lemma
                LIMIT ?}

	cleaned = sanitize_sql [sql, "#{part}%", limit]
      	ActiveRecord::Base.connection.select_values(cleaned)
    end

  end
end
