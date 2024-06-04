class Comment < ApplicationRecord
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, as: :commentable
  belongs_to :commentable, polymorphic: true, touch: true
  

  validates :body, presence: true, length: { minimum: 10 }

end
