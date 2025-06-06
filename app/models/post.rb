class Post < ApplicationRecord
  #Belongs to the user which created this
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  #Belongs to category Many posts can have 1 category
  belongs_to :category
  #set required params for post 
  #Set requirement for title, it is required, with minimum length of  2
  validates :title, presence: true, length: {
    minimum: 2,
    maximum: 120,
    too_short: " must not be shorter than %{count} characters ",
    too_long: " must not be longer than %{count} characters"
}
  #Make sure that category is selected
  validates :category, presence: true
  #Set requirement for content of post, it is required, with minimum length of  2
  validates :content, presence: true, length: {
    minimum: 2,
    maximum: 2500,
    too_short: " must not be shorter than %{count} characters",
    too_long: " must not be longer than 2500 characters"
}
  #1-N association define that 1 post can have many notifications
  has_many :notifications, foreign_key: :post_id, dependent: :destroy
  #1-N association define that 1 post can have many comments
  #Delete associated comments when post is deleted
  has_many :comments, dependent: :destroy
  #Define that post can have many replies
  #which are defined through comments 
  #and use previously defined :replies, which are defined in comment model
  has_many :replies, through: :comments, source: :replies
  #Get all active posts (not archived posts) and sort them by time of update in descending order
  #Will get the posts which were newly created, edited or commented on
  scope :recent_posts, -> {active.order(updated_at: :desc) }
  #Get archived posts by querying posts which have an archived_at value
  scope :archived, -> { where.not(archived_at: nil) }
  #Get all non-archived posts by querying only posts which have archived_at set to null
  scope :active, -> { where(archived_at: nil) }
  #Set post types enum
  enum post_type: { article: 'article', post: 'post'}
  #Will only get articles
  scope :articles, -> { where(post_type: :article) }
  #Will only get posts
  scope :posts, -> { where(post_type: :post) }
end