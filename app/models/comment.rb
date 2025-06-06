class Comment < ApplicationRecord
  #Implement association with users
  belongs_to :user
  #Implement association with posts, use touch to change updated_at when doing action with comments
  belongs_to :post, touch: true
  #Implement association with comment as a parent element
  belongs_to :parent, class_name: "Comment", optional: true
  #Implement 1-N, with many being children comments, which connect to parent with parent id
  #use dependant destroy to delete associated comments when parent is deleted
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy
  #Validate that comment body is at least 2 charaters long
  validates :body, presence: true, length: { minimum: 2 }
end
