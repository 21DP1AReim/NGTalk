class NotificationBuilder
    #Def.  text to send to user for specific notifactions
    ACTIONS = {
    post_deleted: {
        message: ->(obj) { "Your post '#{obj.title}' was removed by a moderator. Reason: #{obj.reason}" },
        require_post: false,
        },
    comment_deleted: {
      message: ->(comment) { "Your comment on '#{comment.post.title}' was removed" },
      require_post: false
    },
    user_banned: {
      message: ->(user) { "Your account has been suspended until #{user.ban_expires_at}" },
      require_post: false
    },
    post_unarchived: {
      message: ->(obj) { "Your post '#{obj.title}' was restored by a moderator."},
      require_post: false
    }
    }
  
    def self.create!(user:, actor:, action:, post: nil, notifiable: nil)
        config = ACTIONS.fetch(action)
        
        # Use notifiable first, then post
        message = config[:message].call(notifiable || post)
    
        Notification.create!(
          user: user,
          actor: actor,
          post: post, # This will be nil for deleted posts
          notification_type: action.to_s,
          message: message
        )
    end
end

