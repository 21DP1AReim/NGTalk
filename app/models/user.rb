class User < ApplicationRecord
  validate :user_name_cannot_contain_symbol
  ROLES = %w[admin editor writer user]

  def admin?
    role == 'admin'
  end
  
  def editor?
    role == 'editor'
  end
  def user?
    role = 'user'
  end

  def self.ransackable_attributes(auth_object = nil)
    ["email", "user_name"]
  end


  
  validates :user_name, presence: true
  validate :validate_user_name_format

  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'user_id'

  has_many :commented_posts, through: :comments, source: :post
  has_many :notifications, foreign_key: :user_id, dependent: :destroy

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def activity_posts
    Post.where(id: posts.select(:id))
        .or(Post.where(id: commented_posts.select(:id)))
        .distinct
        .order(created_at: :desc)
  end


  private

  def validate_user_name_format
    unless user_name.match?(/\A(?=.*[A-Za-z])\w+\z/) && user_name.length >= 3
      if user_name.length < 3
        errors.add(:user_name, "must be longer than 3 characters")
      elsif !user_name.match?(/[A-Za-z]/)
        errors.add(:user_name, "must contain at least one letter")
      else
        errors.add(:user_name, "must contain only letters, numbers, and underscores")
      end
    end
  end

  def user_name_cannot_contain_symbol
    if user_name&.include?('@')
      errors.add(:user_name, "can't contain '@'")
    end
    if user_name&.include?(' ')
      errors.add(:user_name, "can't contain whitespace")
    end
  end
end