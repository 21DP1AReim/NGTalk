class SearchController < ApplicationController
  def index
    query = params[:q].to_s.strip
    @results = []

    if query.present?
      @results = Post.active.where("LOWER(title) LIKE ?", "%#{query.downcase}%")
    end

    respond_to do |format|
      format.html # renders search/index.html.erb
      format.js   # renders search/index.js.erb
    end
  end
end
