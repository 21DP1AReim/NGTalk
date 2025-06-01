class PostsController < ApplicationController
  #Function to set base variables to show a view for specific post
  def show
    #Get the post together with the author and associated comments
    @post = Post.includes(:author, :comments).find(params[:id])
    @author = @post.author
    #Create a new object for a comment, because by default shows a form for comment creation
    @comment = @post.comments.new
    @recent_posts = Post.active.recent_posts.limit(10)
  end
  #Function to set form variables when showing the posts/new_article view
  def new_article
    @post = Post.new(post_type: :article) #Make a new post object with type of article
    @categories = Category.active #Get all active categories
  end
  #Function to set form variables when showing the posts/new_post view
  def new_post
    @post = Post.new(post_type: :post) #Make a new post object with type of post
    @categories = Category.active #Get all active categories
  end
  #Function to create a new post with type article
  def create_article
    #Build a new post with association to current user
    @post = current_user.posts.build(post_params)
    @post.post_type = :article #Set the post type
    #If post was saved redirect to post show view, else show the form with errors
    if @post.save
      redirect_to @post, notice: 'Article was successfully created.'
    else
      @categories = Category.active
      render :new_article
    end
  end
  #Function to create a post with type of post
  def create_post
    #Build a new with association to current user
    @post =current_user.posts.build(post_params)
    @post.post_type = 'post' #Set the post type to post
    #If could create a new post then redirect to post view, else show any errors 
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      @categories = Category.active
      render :new_post
    end
  end
  #Function to arhchive post, arhived posts can only be viewed by admins
  def destroy
    @post = Post.find(params[:id])
    # Find post and try to update its archived at value to current time
    if @post.update(archived_at: Time.current)
      #If could update then set variables used to build notification
      post_title = @post.title #Set the post title
      post_author = @post.author #Set the person which created the post 
      post_type = @post.post_type #Set the type of post
      delete_reason = params[:delete_reason] #Get the deletion reasion admin has provided
      #Try to create a notification, if failes will redirect back to post with error
      NotificationBuilder.create!(
        user: post_author, #Set the author of the post, the user which will recieve the notif
        actor: current_user, #Set the user which initiated the archiving, not displayed anywhere, however can see in db
        action: :post_deleted, #Set the type of message to send, which is based on the action
        notification_text: { #Set the context to send to user, like the name of the post that was removed and the reason
          title: post_title,
          reason: delete_reason
        }     
      )
      #Redirect the user to view with list of posts
      redirect_to posts_path(post_type: post_type), notice: 'Post archived'
    else
      #Otherwise stay on the post page
      redirect_to @post, alert: 'Failed to archive post'
    end
  end
  #Function to purge a post from the system - delete a post permanantly 
  def purge
    #Find the post and get its post type
    @post = Post.find(params[:id])
    post_type = @post.post_type
    @post.destroy! #Delete the post and redirect user to view with list of archived posts
    redirect_to posts_path(archived: true, post_type: post_type), notice: 'Post permanently deleted'
  end
  #Function to restore an archived post
  def restore
    #Find the post to restore and make sure the user which is restoring the post has the authority
    @post = Post.find(params[:id])
    authorize! :update, @post 
    #If succeeded in updating post archived_at field to null then send a notification
    if @post.update(archived_at: nil)
      #Create a notification, which is sent to the author of the restored post
      NotificationBuilder.create!(
        user: @post.author, #Restored post author
        actor: current_user, #Admin which is restoring the post
        action: :post_unarchived, #The action, notif text depends on action
        notification_text: {title: @post.title} #Set notification context text
      )
      #In a way reload the page by redirecting user to the post page with some text
      redirect_to @post, notice: 'Post successfully restored.'
    else
      redirect_to @post, alert: 'Failed to restore post.'
    end
  end
  #Function to edit post content
  def edit
    #Find the post and call the script in posts/edit.js.erb, make sure no added html is rendered 
    @post = Post.find(params[:id])
    respond_to do |format|
      format.js { render layout: false }
    end
  end
  #Function to save the edited content of the post
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
    #If post successfully updates reload the post content to show the updated values   
    if @post.update(post_params)
      format.html { redirect_to @post, notice: 'Post was successfully updated.' }
    else #Otherwise if failed cancel any changes
      format.html { redirect_to @post, notice: 'Post failed to be updated.' }
    end
    end
  end

  def index
    @posts = Post.all
    @posts = @posts.where(post_type: params[:post_type]) if params[:post_type].present?
    @recent_posts = Post.active.recent_posts.limit(10)

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
