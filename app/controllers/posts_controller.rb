class PostsController < ApplicationController
  load_and_authorize_resource

  
  def create_post
    @post = Post.new(post_params)
    @post.post_type = 'post'
    
  def create_post
    @post = Post.new(post_params)
    @post.post_type = 'post' 

    @post.author_id = current_user.id
    authorize! :create, @post 
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new_post
    end
  end

  def create_article
    @post = Post.new(post_params)

    @post.post_type = 'article'
    @post.author_id = current_user.id
    authorize! :create, @post
    if @post.save
      redirect_to @post, notice: 'Article was successfully created.'
    else
      render :new_article
    end
  end

  def new_post
    @post = Post.new
    @post.author_id = current_user.id
    @post.post_type = 'post'
  end
  
  def new_article
    @post = Post.new
    @post.post_type = 'article'
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
    # Start with a base query
    @posts = Post.all

    # Apply post_type filter first
    @posts = @posts.where(post_type: params[:post_type]) if params[:post_type].present?

    # Apply category filter
    if params[:category].present?
      @posts = params[:category] == 'All' ? @posts : @posts.where(category: params[:category])
    end

    # Apply sorting on the filtered posts
    if params[:sort_by].present?
      case params[:sort_by]
      when 'title_asc'
        @posts = @posts.order(title: :asc)
      when 'title_desc'
        @posts = @posts.order(title: :desc)
      when 'replies_asc'
        @posts = @posts.left_joins(:comments, :replies)
                       .select('posts.*, COUNT(DISTINCT comments.id) + COUNT(DISTINCT replies.id) AS total_count')
                       .group('posts.id')
                       .order('total_count ASC')
      when 'replies_desc'
        @posts = @posts.left_joins(:comments, :replies)
                       .select('posts.*, COUNT(DISTINCT comments.id) + COUNT(DISTINCT replies.id) AS total_count')
                       .group('posts.id')
                       .order('total_count DESC')
      when 'activity_asc'
        @posts = @posts.order(updated_at: :asc)
      when 'activity_desc'
        @posts = @posts.order(updated_at: :desc)
      end
    else
      @posts = @posts.order(updated_at: :desc)
    end

    @posts = @posts.page(params[:page]).per(18)
  end

  def notindex
    @posts = Post.order(updated_at: :desc)

    @posts = if params[:category].present?
               if params[:category] == 'All'
                 Post.all.order(updated_at: :desc)
               else
                 Post.where(category: params[:category])
               end
             else
               Post.all.order(updated_at: :desc)
             end

    if params[:sort_by].present?
      case params[:sort_by]
      when 'title_asc'
        @posts = Post.order(title: :asc)
      when 'title_desc'
        @posts = Post.order(title: :desc)
      when 'replies_asc'
        @posts = Post.left_joins(:comments, :replies).select('posts.*, COUNT(DISTINCT comments.id) + COUNT(DISTINCT replies.id) AS total_count').group('posts.id').order('total_count ASC')
      when 'replies_desc'
        @posts = Post.left_joins(:comments, :replies).select('posts.*, COUNT(DISTINCT comments.id) + COUNT(DISTINCT replies.id) AS total_count').group('posts.id').order('total_count DESC')
      when 'activity_asc'
        @posts = Post.order(updated_at: :asc)
      when 'activity_desc'
        @posts = Post.order(updated_at: :desc)
      else
        Post.all
      end
    end

    @posts = @posts.where(post_type: params[:post_type]) if params[:post_type].present?
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
    params.require(:post).permit(:title, :category, :content, :author_id, :post_type)
  end
end
