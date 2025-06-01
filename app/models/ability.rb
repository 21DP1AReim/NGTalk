class Ability
  #Define that this is using CanCan
  include CanCan::Ability
  #Function to initialize user roles
  def initialize(user)
    #If user is new
    user ||= User.new
    #If user is admin can do everything
    if user.admin?
      can :manage, :all
    #Otherwise can read all
    else
      can :read, :all
      #If user is logged in, so any user
      if user.persisted?
        can :create, Comment

        case user.role
        when 'writer'
          can :create, Post # Writers can create both articles and posts
          #Writers can edit their own posts with no time constraints
          can :edit, Post do |post|
            post.author_id == user.id 
          end
        when 'user'
          can :create, Post, post_type: 'post' # Users can only create regular posts
          can :new, Post # allow access to the form
          #Users can edit their own post, if it is within a 15 minute creation timeframe 
          can :edit, Post do |post|
            post.author_id == user.id && post.created_at > 15.minutes.ago
          end
        end
      end
    end
  end
end