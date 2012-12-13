#coding: utf-8
class DdoMappingsController < ApplicationController
  def show
    @ddo_mapping = DanNet::DdoMapping.find_by_ddo_id(params[:id])
    if @ddo_mapping
      redirect_to word_redirect_path(@ddo_mapping.word_sense), :status => :moved_permanently
    else
      render :text => t(:not_found_notice, :wordnet => "DanNet"), :status => :not_found
    end
  end
end
