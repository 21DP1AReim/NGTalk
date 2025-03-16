class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, :all
      if user.persisted?
        can :create, Comment
        case user.role
        when 'editor'
          can :manage, [Post, Comment]
        when 'writer'
          can :create, Post # Writers can create both articles and posts
        when 'user'
          can :create, Post, post_type: 'post' # Users can only create regular posts
        end
        can :manage, Post, author_id: user.id
        cannot :manage, User
      end
    end
  end
end