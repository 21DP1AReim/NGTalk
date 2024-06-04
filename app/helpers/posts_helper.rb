module PostsHelper
  def time_ago_in_words(time)
    seconds_ago = Time.now - time
    if seconds_ago < 60
      "#{seconds_ago.round} seconds ago"
    elsif seconds_ago < 3600
      "#{(seconds_ago / 60).round} minutes ago"
    elsif seconds_ago < 86_400
      "#{(seconds_ago / 3600).round} hours ago"
    elsif seconds_ago < 2_592_000
      "#{(seconds_ago / 86_400).round} days ago"
    else
      "#{(seconds_ago / 2_592_000).round} months"
    end
  end
end
