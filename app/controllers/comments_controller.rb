class CommentsController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :find_commentable, only: [:create]

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.includes(:replies)

  end

def create
  @commentable = find_commentable
  @parent_comment = Comment.find_by(id: params[:comment][:parent_id])
  @comment = @commentable.comments.build(comment_params)

  if params[:comment][:reply_to_reply] == "true" && @parent_comment.present?
    @comment.parent_id = @parent_comment.parent_id || @parent_comment.id
  end

  respond_to do |format|
    if @comment.save
      @comments = @commentable.comments.order(created_at: :desc)

      format.html do 
        if @commentable.is_a?(Post)
          redirect_to post_path(@commentable), notice: 'Comment was successfully created.'
        elsif @commentable.is_a?(Article)
          redirect_to article_path(@commentable), notice: 'Comment was successfully created.'
        end
      end

      format.js {}
    else
      format.html do 
        if @commentable.is_a?(Post)
          redirect_to post_path(@commentable), alert: 'Comment could not be created.'
        elsif @commentable.is_a?(Article)
          redirect_to article_path(@commentable), alert: 'Comment could not be created.'
        end
      end

      format.js { render template: 'shared/error.js.erb', locals: { object: @comment }, status: :unprocessable_entity }
    end
  end
end

  def destroy
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to @comment.commentable, notice: 'Comment was successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @comment.commentable, alert: 'Comment could not be deleted.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body).merge(commentable_type: @commentable.class.name, commentable_id: @commentable.id)
  end

  def find_commentable
    if params[:post_id]
      @commentable = Post.find(params[:post_id])
    elsif params[:article_id]
      @commentable = Article.find(params[:article_id])
    end
  end

  def find_commentable_type
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize
      end
    end
    nil
  end
end