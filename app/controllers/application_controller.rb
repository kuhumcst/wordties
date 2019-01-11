class ApplicationController < ActionController::Base
  protect_from_forgery

  protect_from_forgery
  include ApplicationHelper
  def default_url_options
    if Rails.env.production?
      {:host => "wordties.cst.sc.ku.dk"}
    else
      {:host => "wordties.cst.dk"}
    end
  end

  protected
  def bind_query
    @query = params[:query] and params[:query].strip.downcase
  end

end
