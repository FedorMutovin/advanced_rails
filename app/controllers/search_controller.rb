class SearchController < ApplicationController
  protect_from_forgery except: :search
  skip_authorization_check

  def search
    @search_results = SphinxSearch.search_results(params[:search_text], params[:search_object]) if params[:search_text] && params[:search_object]
  end
end
