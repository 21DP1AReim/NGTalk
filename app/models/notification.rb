class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: 'User', optional: true
  belongs_to :post, optional: true

  scope :for_user, ->(user) { where(user: user) }
  scope :sorted, -> { order(created_at: :desc) }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { sorted.limit(10) }
end