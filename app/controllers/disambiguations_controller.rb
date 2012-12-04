#coding: utf-8
class DisambiguationsController < ApplicationController
  require 'uri'
  before_filter :bind_query
  before_filter :bind_senses, :only => :show

  def show
  end

  def bind_senses
    @senses = DanNet::Word.find_all_by_lemma(@query).map(&:word_senses)
    @filter = params[:filter]
    @senses = @senses.flatten

    if @filter.end_with? 'aligned'
      @senses.delete_if {|ws| DanNet::Alignment.find_all_by_syn_set_id(ws.syn_set_id).empty? }
    end

    if @filter == 'ml_aligned'
      @senses.delete_if {|ws| DanNet::Alignment.find_all_by_syn_set_id_and_through_source_id(ws.syn_set_id, 'wordnet30').empty? }
    end

    @senses = @senses.sort_by {|ws| ws.heading }

    if @senses.length < 1
	redirect_to correct_spelling_path(@query)
    elsif @senses.length == 1
	redirect_to ord_path(@senses.first), :status => :moved_permanently
    end
  end

end
