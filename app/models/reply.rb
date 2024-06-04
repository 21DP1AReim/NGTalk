class Reply < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :comment
  has_many :replies, dependent: :destroy


  validates :body, presence: true, length: { minimum: 1 }

  
  def destroy_all_nested_replies
    replies.each do |nested_reply|
      nested_reply.destroy_all_nested_replies
    end
    destroy
  end
end