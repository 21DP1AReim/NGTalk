class NotificationBuilder
    #Define the text for specific actions, which are passed when creation notif in controller function when deleting/doing the action that should create a notification
    ACTIONS = {
    post_deleted: {
        message: ->(obj) { "Your post '#{obj[:title]}' was removed by a moderator. Reason: #{obj[:reason]}" }
        },
    comment_deleted: {
      message: ->(comment) { "Your comment on '#{comment.post.title}' was removed" }
    },
    post_unarchived: {
      message: ->(obj) { "Your post '#{obj[:title]}' was restored by a moderator."}
    }
    }
    
    def self.create!(user:, actor:, action:, post: nil, notification_text: nil)
        notif_action = ACTIONS.fetch(action) #Get the notification action placeholder text
        
        # Use variables passed in notification text to insert into the message of action, if no text use post columns
        message = notif_action[:message].call(notification_text || post)
    
        Notification.create!(
          user: user,
          actor: actor,
          post: post, 
          notification_type: action.to_s, #Convert action to string and save it as notif type
          message: message #Set the msg to send
        )
    end
end

