#coding: utf-8
class DisambiguationsController < ApplicationController
  before_filter :bind_query
  before_filter :bind_senses, :only => :show

  def show
  end

  def bind_senses
    @filter = params[:filter]
    @senses = DanNet::Word.find_all_by_lemma(@query).map(&:word_senses)
    @senses = @senses.flatten

    if @filter.end_with? Rails.configuration.search_filter_aligned_postfix
      @senses.delete_if {|ws| DanNet::Alignment.find_all_by_syn_set_id(ws.syn_set_id).empty? }
    end

    if @filter == Rails.configuration.search_filter_ml + Rails.configuration.search_filter_aligned_postfix
      @senses.delete_if {|ws| DanNet::Alignment.find_all_by_syn_set_id_and_through_source_id(ws.syn_set_id, 'wordnet30').empty? }
    end

    @senses = @senses.sort_by {|ws| ws.heading }

    if @senses.length < 1
	  redirect_to correct_spelling_path(@query)
    elsif @senses.length == 1
	  redirect_to w_filter_path(@filter, @senses.first), :status => :moved_permanently
    end
  end

end
