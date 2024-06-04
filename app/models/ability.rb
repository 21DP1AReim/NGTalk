# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
  

      user ||= User.new
      if user.admin?
        can :manage, :all
      elsif user.editor?
        can :manage, [Article, Comment, Post]
        can :create, [Article, Comment, Post]
        cannot :manage, User
      elsif user.writer?
        can :create, [Article, Comment, Post]
        can :read, :all
        cannot :manage, User
      elsif user.user?
        can :create, [Post, Comment]
        can :read, :all
        cannot :manage, User
      else
        can :read, :all
        cannot :manage, User
      end
    
  end
end
