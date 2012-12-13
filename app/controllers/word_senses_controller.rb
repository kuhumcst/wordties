#coding: utf-8
class WordSensesController < ApplicationController
  before_filter :bind_query, :only => :search
  before_filter :find_sense, :only => :search

  def show
    @filter = params[:filter]
    @sense  = DanNet::WordSense.find(params[:id])

    if params[:id] != @sense.to_param
	redirect_to w_filter_path(@filter, @sense), :status=> :moved_permanently
    end

    @syn_set  = @sense.syn_set
    @alignments_wordnet = @syn_set.alignments.where({:through_source_id => nil})
    @alignments_through = @syn_set.alignments.where({:through_source_id => "wordnet30"}).sort_by(&:source)
    @title = "#{@sense.heading} – #{@syn_set.gloss}"
    @synonyms = @sense.synonyms
    @hyponyms = @syn_set.hyponyms.sort_by(&:pretty_label)
    @features = @syn_set.features
    bind_paths
    bind_related_syn_sets
  end

  def search
    if DanNet::Word.find_by_lemma(@query)
      redirect_to disambiguage_word_sense_path(@filter, @query)
    else
      redirect_to correct_spelling_path(@query)
    end
  end

  def find_sense
    @filter = (!params[:filter].nil?) ? params[:filter] : "full"
    @sense = DanNet::WordSense.find_by_heading(@query)
    if @sense
	# TODO: clean up code seg/redirection
	if @sense.syn_set.alignments.nil? && @filter.end_with?(Rails.configuration.search_filter_aligned_postfix)
	  redirect_to w_filter_path(@filter, @sense), :status => :moved_permanently
	elsif !@filter.end_with?(Rails.configuration.search_filter_aligned_postfix)  
      	  redirect_to w_filter_path(@filter, @sense), :status => :moved_permanently
	end  
    end  
  end

  def best_for_syn_set
    syn_set = DanNet::SynSet.find(params[:syn_set_id])
    filter = params[:filter]
    #filter = syn_set.getFilterByAlignments(params[:filter])
    redirect_to w_filter_path(filter, syn_set.word_senses.first), :status => :moved_permanently
  end

  private
  def bind_paths
    @paths_to_top = @syn_set.paths_to_top.sort_by(&:size)
    # Take first element if all elements are of the same size
    if first = @paths_to_top.first
      @paths_to_top = [first] if @paths_to_top.all? {|path| first.size == path.size }
    end
  end

  def bind_related_syn_sets
    graph = DanNet::WordSenseGraph.new(@sense)
    @related_syn_sets = Hash.new
    @related_syn_sets['name'] = @sense.word.lemma
    @related_syn_sets['link'] = ''
    @related_syn_sets['children'] = Array.new
    graph.capped_relation_groups(140,100).each do |rel_type,syn_sets|
      syn_sets.each do |syn_set|
	#filter = syn_set.getFilterByAlignments(@filter)
	link = !syn_set.internal? ? w_filter_path(@filter, syn_set.word_senses.preferred) : ''
	@related_syn_sets['children'].push({	
	  'name'     => syn_set.pretty_label,
          'link'     => link,
          'synonyms' => syn_set.words.map(&:lemma)*',',
          'gloss'    => syn_set.gloss,
	  'rel_type_key' => rel_type.name,
	  'rel_type' => t(rel_type.name)
        })
      end
    end
  end

###Deprecated Protovis graph vis method
#  def bind_related_syn_sets_protovis
#    graph = DanNet::WordSenseGraph.new(@sense)
#    related_syn_sets = Hash.new {|h,k| h[k] = {} }
#    graph.capped_relation_groups(140,100).each do |rel_type,syn_sets|
#      syn_sets.each do |syn_set|
#	link = !syn_set.internal? ? w_path(syn_set.word_senses.preferred) : ''
#        related_syn_sets[t(rel_type.name)][syn_set.pretty_label] = {
#          'link'     => link,
#          'synonyms' => syn_set.words.map(&:lemma)*',',
#          'gloss'    => syn_set.gloss
#        }
#      end
#    end
#    related_syn_sets
#  end

end
