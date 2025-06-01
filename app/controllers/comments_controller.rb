class CommentsController < ApplicationController
  before_action :authenticate_user! #Make sure user is logged in 
  #Make sure post is set, only called when controller called to handle create and delete of comments
  before_action :set_post, only: [:create, :destroy] 
  before_action :set_comment, only: [:destroy] #Make sure controller knows which comment to delete
  skip_forgery_protection only: :reply, if: -> { request.format.js? } #Used to skip error

  def index
    #Find the post on which the comments are created on
    @post = Post.find(params[:post_id])
    #Get all first level parents - comments which are not replies to a different comment
    #Use includes to also query for any associated replies, rplies defined in model
    @comments = @post.comments.where(parent_id: nil).includes(:replies).order(created_at: :desc)
  end
  #Function to set form data for reply forms to comments, and to load js file that creates a reply creation form
  def reply
    #Find the parent comment
    @parent_comment = Comment.find(params[:id])
    #Build a comment, used to create a reply form, which when submited sends these values to the create function
    @comment = @parent_comment.post.comments.build(
      parent_id: @parent_comment.id, #Id of the comment that reply is being created on
      user: current_user, #User that is created the reply
      post: @parent_comment.post #The post on which the comment is being created on
    )
    #Load the comments/reply.js.erb script
    respond_to do |format|
      format.js
    end
  end
  #Function to create a new comment
  def create
    @comment = @post.comments.build(comment_params) #Build the comment using the parameters provided
    @comment.user = current_user #Set the user which is creating the comment
    #Set view variables, since loading the view again manually
    @comments = @post.comments.where(parent_id: nil).order(created_at: :desc)
    @recent_posts = Post.order(updated_at: :desc).limit(10)
    respond_to do |format|
      if @comment.save
        #If comment was saved successfully will render the post page and will call comments/create.js.erb script
        format.html { redirect_to @post, notice: 'Comment posted!' }
        format.js  
        #Otherwise will stay on the same page and show errors, manually calls comments/errors.js.erb
      else
        format.html { render 'posts/show' }
        format.js { render :error }
      end
    end
  end
  def destroy
    #Destroy the comment and redirect them to the post the comment got deleted on, to rerload the view in a way
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @post, notice: 'Comment deleted!' }
    end
  end
  private
  #Function to find the post the comment is created on
  def set_post
    @post = Post.find(params[:post_id])
  end
  #Function to find the comment for deletion
  def set_comment
    @comment = Comment.find(params[:id])
  end
  #Set the permited params for comments
  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end