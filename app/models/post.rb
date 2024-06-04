class Post < ApplicationRecord
  validates :author_id, presence: true
  validates :title, presence: true
  validates :category, presence: true
  validates :content, presence: true
  has_many :comments, as: :commentable
  has_many :replies, through: :comments
  before_destroy :delete_associated_comments

  def self.ransackable_attributes(auth_object = nil)
    ["title"]
  end


  private

  def delete_associated_comments
    comments.destroy_all
  end
end