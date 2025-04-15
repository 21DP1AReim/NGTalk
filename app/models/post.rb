class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  validates :title, presence: true

  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
  validates :categories, presence: true
  accepts_nested_attributes_for :categories

  


  has_many :comments, dependent: :destroy
  has_many :replies, through: :comments, source: :replies
  validates :content, presence: true

  scope :recent_posts, -> { order(created_at: :desc).limit(5) }

  enum post_type: { article: 'article', post: 'post'}

  scope :articles, -> { where(post_type: :article) }
  scope :posts, -> { where(post_type: :post) }
  def self.ransackable_attributes(auth_object = nil)
    ["title"]
  end


  private

  def delete_associated_comments
    comments.destroy_all
  end
end