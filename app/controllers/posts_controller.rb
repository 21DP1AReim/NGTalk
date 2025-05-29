class PostsController < ApplicationController
  load_and_authorize_resource
  
  def create_post
    @post = Post.new(post_params)
    @post.post_type = 'post'
    @post.author_id = current_user.id
    authorize! :create, @post 
    
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      @categories = Category.all
      render :new_post
    end
  end


  def show
    @post = Post.includes(:author, :comments).find(params[:id])
    @author = @post.author
    @comment = @post.comments.new
    @comments = @post.comments.where(parent_id: nil).order(created_at: :desc)
    @recent_posts = Post.recent_posts.limit(10)
  end

  def new_article
    @post = Post.new(post_type: :article)
    @categories = Category.all
  end
  
  def create_article
    @post = current_user.posts.build(post_params)
    @post.post_type = :article
    
    if @post.save
      redirect_to @post, notice: 'Article was successfully created.'
    else
      @categories = Category.all
      render :new_article
    end
  end

  def destroy
    @post = Post.find(params[:id])
    
    # Archive instead of delete
    if @post.update(archived_at: Time.current)
      # Notification remains the same
      post_title = @post.title
      post_author = @post.author
      post_type = @post.post_type
      delete_reason = params[:delete_reason]
  
      NotificationBuilder.create!(
        user: post_author,
        actor: current_user,
        action: :post_deleted,
        notifiable: OpenStruct.new(
          title: post_title,
          reason: delete_reason
        )      
      )
      
      redirect_to posts_path(post_type: post_type), notice: 'Post archived'
    else
      redirect_to @post, alert: 'Failed to archive post'
    end
  end
  
  def purge
    @post = Post.find(params[:id])
    post_type = @post.post_type
    @post.destroy!
    redirect_to posts_path(archived: true, post_type: post_type), notice: 'Post permanently deleted'
  end


  def restore
    @post = Post.find(params[:id])
    authorize! :update, @post 
  
    if @post.update(archived_at: nil)
      NotificationBuilder.create!(
        user: @post.author,
        actor: current_user,
        action: :post_unarchived,
        notifiable: OpenStruct.new(title: @post.title)
      )
  
      redirect_to @post, notice: 'Post successfully restored.'
    else
      redirect_to @post, alert: 'Failed to restore post.'
    end
  end

  def edit
    @post = Post.find(params[:id])
    respond_to do |format|
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
    @posts = Post.all
    @posts = @posts.where(post_type: params[:post_type]) if params[:post_type].present?

    #Only alow to view archived page if user has admin role
    if params[:archived] && !current_user&.admin?
      redirect_to root_path, alert: "You cannot access this!"
      return
    end
    #If archived is sent to controller then return only archived posts, otherwise only active posts
    @posts = params[:archived] ? @posts.archived : @posts.active

    if params[:category].present? && params[:category] != 'All'
      @posts = @posts.joins(:category).where(categories: { name: params[:category] })
    end
  
    if params[:sort_by].present?
      case params[:sort_by]
      when 'title_asc'
        @posts = @posts.order(title: :asc)
      when 'title_desc'
        @posts = @posts.order(title: :desc)
      when 'replies_asc'
        @posts = @posts.left_joins(comments: :replies)
                       .select('posts.*, 
                               COUNT(DISTINCT comments.id) + 
                               COUNT(DISTINCT replies_comments.id) AS total_comments')
                       .group('posts.id')
                       .order('total_comments ASC')
      when 'replies_desc'
        @posts = @posts.left_joins(comments: :replies)
                       .select('posts.*, 
                               COUNT(DISTINCT comments.id) + 
                               COUNT(DISTINCT replies_comments.id) AS total_comments')
                       .group('posts.id')
                       .order('total_comments DESC')
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

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_type, :category_id)
  end
end
