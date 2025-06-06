class Notification < ApplicationRecord
  belongs_to :user #1 TO N, 1 user can have many notifs
  belongs_to :actor, class_name: 'User', optional: true #Also user but the user whose actions resulted in a notification creation
  belongs_to :post, optional: true #Belongs to post in case when notifaction is related to a post
  
  scope :for_user, ->(user) { where(user: user) }
  #Query to sort notifications belonging to user by created date time, newest fisr
  scope :sorted, -> { order(created_at: :desc) }
  #Query to get all unread notifications
  scope :unread, -> { where(read_at: nil) }
  #Query to only get the most recent 10 notifications
  scope :recent, -> { sorted.limit(10) }
end