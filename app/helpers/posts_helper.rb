module PostsHelper
  def time_ago_in_words(time)
    seconds_ago = Time.now - time
    #If block to find the passed time, use pluralize to convert "second" to "seocnds", if count is more than 1
    #If 1 minute has not passed
    if seconds_ago < 60
      #Then round seconds to the nearest second, to make sure seconds is an integer
      count = seconds_ago.round
      #Return string as (seconds) (second/s) ago
      "#{count} #{'second'.pluralize(count)} ago"
    #If 1 hour has not passed  
    elsif seconds_ago < 3600
      #Then round seconds to the nearest minute, to make sure minutes is an integer
      count = (seconds_ago / 60).round
      #Return string as (minutes) (minute/s) ago
      "#{count} #{'minute'.pluralize(count)} ago"
    #If a day has not passed  
    elsif seconds_ago < 86_400
      #Then round seconds to the nearest hour, to make sure hours are an integer
      count = (seconds_ago / 3600).round
      #Return string as (hours) (hour/s) ago
      "#{count} #{'hour'.pluralize(count)} ago"
    #If a month has not passed  
    elsif seconds_ago < 2_592_000
      #Then round seconds to the nearest day, to make sure days are an integer
      count = (seconds_ago / 86_400).round
      #Return string a (days) (day/s) ago
      "#{count} #{'day'.pluralize(count)} ago"
    else
      #Else get the rounded number of months
      count = (seconds_ago / 2_592_000).round
      #Return string as (month) (month/s) ago
      "#{count} #{'month'.pluralize(count)} ago"
    end
  end
end
