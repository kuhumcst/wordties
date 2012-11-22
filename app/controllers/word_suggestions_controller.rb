#coding: utf-8
class WordSuggestionsController < ApplicationController

  def index
    lemmas = DanNet::Word.suggest_lemmas_by_part(params[:query])
    render_text(lemmas)
  end

  def filter
    if params[:filter] == "aligned" 
	lemmas = DanNet::Word.suggest_lemmas_by_part(params[:query], params[:filter])
	render_text(lemmas)
    else
	index
    end
  end

  def render_text(lemmas)
    render :text => lemmas*"\n"
  end

end
