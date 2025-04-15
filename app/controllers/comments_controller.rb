class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]
  skip_forgery_protection only: :reply, if: -> { request.format.js? }

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.where(parent_id: nil).includes(:replies)
  end

  def reply
    @parent_comment = Comment.find(params[:id])
    @comment = @parent_comment.post.comments.build(
      parent_id: @parent_comment.id,
      user: current_user,
      post: @parent_comment.post
    )
    
    respond_to do |format|
      format.js
    end
  end

  def create
    @post = Post.find(params[:post_id]) # Make sure @post is set
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
    # Set all required instance variables for the view
    @author = @post.author
    @comments = @post.comments.where(parent_id: nil).order(created_at: :desc)
    @recent_posts = Post.order(created_at: :desc).limit(5)
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: 'Comment posted!' }
        format.js  
      else
        format.html { render 'posts/show' }
        format.js { render :error }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @post, notice: 'Comment deleted!' }
      format.js
    end
  end


  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end