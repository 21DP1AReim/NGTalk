class PagesController < ApplicationController
 def main_page
   @recent_posts = get_recent_posts 
   @recent_articles = Article.order(updated_at: :desc).limit(18)
  end
  def stylesheet
    send_file 'app/assets/stylesheets/application.css', type: 'text/css', disposition: 'inline'
  end

  def g
    send_file 'app/assets/images/g.png', type: 'image/png', disposition: 'inline'
  end

def make_post_page
    render 'pages/make_post_page'
  end

  def make_post_page
    @post = Post.new
  end

  def create_post
    @post = Post.new(post_params)

    if @post.save
      redirect_to root_path
    else
      render :make_post_page
    end
  end

  private

  def get_recent_posts
    Post.order(updated_at: :desc).limit(10)
  end
  
  def post_params
    params.require(:post).permit(:title, :category, :content, :author_id)
  end

end