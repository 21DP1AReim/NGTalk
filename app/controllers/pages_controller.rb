class PagesController < ApplicationController
  #Function to get information to show recent articles and most recent activity on main page
  def main_page
    @recent_posts = Post.recent_posts.limit(10)
    @recent_articles = Post.where(post_type: 'article').order(created_at: :desc).limit(18)
  end

end
