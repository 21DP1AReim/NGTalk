class RepliesController < ApplicationController
  def new
    @comment = Comment.find(params[:comment_id])
    @reply = Reply.new(comment: @comment)
    @reply.comment_id = @comment.id

    respond_to do |format|
      format.html { render }
      format.js { render locals: { comment: @comment, reply: @reply } }
    end
  end

  def index
    @comment = Comment.find(params[:comment_id])
    @reply = Reply.new(comment: @comment) 
    respond_to do |format|
      format.html { render } 
      format.js { render } 
    end
  end


  
  def create
    @comment = Comment.find(params[:comment_id])

    if params[:reply_id].present?
      @parent_reply = Reply.find(params[:reply_id])
      @reply = @parent_reply.replies.build(reply_params)
    else
      @reply = @comment.replies.build(reply_params)
    end

    @reply.commenter = current_user.userName


     if @reply.save
      respond_to do |format|
        format.js 
        format.html { redirect_to @comment.commentable, notice: 'Reply was successfully created.' } 
      end
    else
      respond_to do |format|
        format.js { render status: :unprocessable_entity }
        format.html { redirect_to @comment.commentable, alert: 'Reply could not be created.' }
      end
    end
  end

def destroy
  @reply = Reply.find(params[:id])

  respond_to do |format|
    if @reply.destroy_all_nested_replies
      format.html { redirect_to @reply.comment.commentable, notice: 'Reply and all nested replies were successfully deleted.' }
      format.json { head :no_content }
    else
      format.html { redirect_to @reply.comment.commentable, alert: 'Reply and nested replies could not be deleted.' }
      format.json { render json: @reply.errors, status: :unprocessable_entity }
    end
  end
end
  
    private

  def reply_params
    params.require(:reply).permit(:comment_id, :commenter, :body)
  end
  
end
