class UsersController < ApplicationController
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

  #Func to build information on my activity page 
  def activity
    @recent_posts = Post.active.recent_posts.limit(10) #To show recent activity bar
    @all_activity = current_user.activity_posts.includes(:author, :comments) #All activity tab
    @my_posts = current_user.posts.includes(:comments) #My posts tab
    @my_commented_posts = Post.joins(:comments) #My commented posts tab
                              .where(comments: { user_id: current_user.id })
                              .distinct
                              .includes(:author, :comments)
  end


  private
  #Define fields required for user signup
  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end

end
