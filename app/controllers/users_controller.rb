class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :read, :edit, :update, :destroy]
  before_action :authorize_admin, only: [:edit, :update, :destroy]
  def signup
    @user = User.new
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
    else
      render 'signup'
    end
  end


  def activity
    @recent_posts = Post.active.recent_posts.limit(10)
    @all_activity = current_user.activity_posts.includes(:author, :comments)
    @my_posts = current_user.posts.includes(:comments)
    @my_commented_posts = Post.joins(:comments)
                              .where(comments: { user_id: current_user.id })
                              .distinct
                              .includes(:author, :comments)
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_admin
    redirect_to root_path, alert: 'You are not authorized to perform this action.' unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end

end
