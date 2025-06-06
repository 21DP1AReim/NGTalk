class User < ApplicationRecord
  #Possible user roles
  ROLES = %w[admin writer user]

  def admin?
    role == 'admin'
  end
  def writer?
    role == 'writer'
  end
  def user?
    role == 'user'
  end

  #Make sure user name passes custom validation for symbols
  validate :user_name_cannot_contain_symbol
  #Make sure user name has value
  validates :user_name, presence: true
  #Make sure username passes vustom validation for name format
  validate :validate_user_name_format
  #Define association with posts 1-N through author id
  #Will delete any posts when user is deleted, because of dependent
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  #Define association with comments 1-N through user id
  #Will destroy any user-made comments when user is deleted
  has_many :comments, foreign_key: 'user_id', dependent: :destroy
  #Define that user can have many posts tey have commented on
  #User for my activity view for user to see commented on posts
  has_many :commented_posts, through: :comments, source: :post
  #Define association with notifications, 1-N, user can have many notifcations
  has_many :notifications, foreign_key: :user_id, dependent: :destroy
  #Define devise actions that can be used through user
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  #Function to get all posts user has been active on
  #posts user has created and posts user has commented on 
  def activity_posts
    #Get arrays of post ids and commented posts ids and combine
    post_ids = posts.pluck(:id) + commented_posts.pluck(:id)
    #Get active posts with unique post ids ordered by created time
    Post.active.where(id: post_ids.uniq)
        #Get associated users and comments, to avoid unneeded queries
      .includes(:author, :comments) 
      .order(created_at: :desc)
  end


  private
  #Function to validate user name format
  def validate_user_name_format
    #Check if username matches regex and is longer or equal to 3 chars
    #if not then go through validation block
    unless user_name.match?(/\A(?=.*[A-Za-z])\w+\z/) && user_name.length >= 3
      #If username lenght is less than 3 characters
      if user_name.length < 3
        errors.add(:user_name, "must be longer than 3 characters")
        #If username doesn't have a single uppercase or lowercase letter
      elsif !user_name.match?(/[A-Za-z]/)
        errors.add(:user_name, "must contain at least one letter")
        #Since no other validation error was found, but the initial validation failed
        #still display an error
      else
        errors.add(:user_name, "must contain only letters, numbers, and underscores")
      end
    end
  end
  #Function to validate username format
  def user_name_cannot_contain_symbol
    #Checks if username exists and has an "@" symbol
    if user_name&.include?('@')
      errors.add(:user_name, "can't contain '@'")
    end
    #Checks if username exists and checks if username has whitespace
    if user_name&.include?(' ')
      errors.add(:user_name, "can't contain whitespace")
    end
  end
end