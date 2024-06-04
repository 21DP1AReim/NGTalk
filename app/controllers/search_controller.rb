class SearchController < ApplicationController
  def index
    @q = params[:q]
    @results = []

    if @q
      @results += Article.ransack(title_cont: @q[:title_cont]).result
      @results += Post.ransack(title_cont: @q[:title_cont]).result
      @results = @results.uniq
    end

    respond_to do |format|
      format.html { render 'index' } 
      format.js { render 'index' }
    end
  end
end