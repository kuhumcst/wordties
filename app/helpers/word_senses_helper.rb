#coding: utf-8
module WordSensesHelper
  def link_word_sense_lemmas(word_senses, filter)
    word_senses.collect do |ws|
      #filter = ws.syn_set.getFilterByAlignments(filter)
      link_to ws.word.lemma, w_filter_path(filter, ws)
    end
  end

  def format_path_to_top(path, filter)
    path.map {|syn_set|
      ws = syn_set.word_senses.first
      #filter = syn_set.getFilterByAlignments(filter)
      link_to(syn_set.pretty_label, w_filter_path(filter, ws))
    }.join(' → ')
  end

  def hyponym_nodes_to_json(syn_sets, filter)
    h = {}
    syn_sets.each do |syn_set|
      extra = {
        'pretty_label' => syn_set.pretty_label,
        'link'         => best_for_syn_set_filter_path(syn_set, filter, :anchor => 'begreber')
      }
      h[syn_set.id] = syn_set.attributes.merge(extra)
    end
    h.to_json.html_safe
  end
  
  def hyponym_tree_to_json(tree, lemma)
    h = {}
    h['name'] = lemma
    h['children'] = tree
    h['link'] = '#begreber'

    h.to_json.html_safe
  end

end
