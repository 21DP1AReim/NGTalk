class SearchController < ApplicationController
  #Function to handle searching
  def index
    #Get recent posts to show in activity tab
    @recent_posts = Post.active.recent_posts.limit(10)
    #Get the user submited search query, strip any whitespace and convert to string
    query = params[:query].to_s.strip
    #Array for results
    @results = []
    #If query variable is set
    if query.present?
      #Get results by searching active posts, querying lowercase titles by lowercase query
      @results = Post.active.where("LOWER(title) LIKE ?", "%#{query.downcase}%")
    end
    #Load index js or index html based on request
    respond_to do |format|
      format.html # renders search/index.html.erb
      format.js   # renders search/index.js.erb
    end
  end
end
