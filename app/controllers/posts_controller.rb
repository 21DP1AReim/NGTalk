class PostsController < ApplicationController
  load_and_authorize_resource
  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def new
    @post = Post.new
    @post.author_id = current_user.id
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def edit
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html { render 'edit' }
      format.js { render layout: false }
    end
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def search
    @search = Post.ransack(params[:search])
    @posts = @search.result(distinct: true)
    render 'index'
  end


  def index
    @posts = Post.order(updated_at: :desc)
    
    if params[:category].present?
      if params[:category] == 'All'
        @posts = Post.all.order(updated_at: :desc)
      else
        @posts = Post.where(category: params[:category])
      end
    else
      @posts = Post.all.order(updated_at: :desc)
    end

    if params[:sort_by].present?
      case params[:sort_by]
      when 'title_asc'
        @posts = Post.order(title: :asc)
      when 'title_desc'
        @posts = Post.order(title: :desc)
      when 'replies_asc'
        @posts = Post.left_joins(:comments, :replies).select("posts.*, COUNT(DISTINCT comments.id) + COUNT(DISTINCT replies.id) AS total_count").group("posts.id").order("total_count ASC")
      when 'replies_desc'
        @posts = Post.left_joins(:comments, :replies).select("posts.*, COUNT(DISTINCT comments.id) + COUNT(DISTINCT replies.id) AS total_count").group("posts.id").order("total_count DESC")
      when 'activity_asc'
        @posts = Post.order(updated_at: :asc)
      when 'activity_desc'
        @posts = Post.order(updated_at: :desc)
      else
        Post.all
      end
    end

      @posts = @posts.page(params[:page]).per(18)


    respond_to do |format|
      format.html
      format.js { render partial: 'sorted_posts', locals: { posts: @posts } }
    end
  end



def show
  @post = Post.find(params[:id])
  @author = User.find(@post.author_id)
  @commentable = @post
  @comments = @post.comments.order(created_at: :desc)
  @comment = Comment.new
  @recent_posts = get_recent_posts
 
end


  private

  def get_recent_posts
    PagesController.new.send(:get_recent_posts)
  end
  
  def post_params
    params.require(:post).permit(:title, :category, :content, :author_id)

  end
end
