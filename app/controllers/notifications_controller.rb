class NotificationsController < ApplicationController
#Function to destroy a notification, can be called by any authorized user
  def destroy
    #Find the notification to delete by looking through all the users notifactions and finding the one with the passed id
    @notification = current_user.notifications.find(params[:id])
    #Delete the notification from the system
    @notification.destroy
    respond_to do |format|
      format.js # Will execute the script int notifications/destroy.js.erb
    end
  end
  #Function to handle when user marks a notification as read 
  def mark_as_read
    #Find the notification user clicked
    @notification = current_user.notifications.find(params[:id])
    #Update the value of read at to the current time, to set the notification as read
    @notification.update(read_at: Time.current)
    respond_to do |format|
      #Run the script in notifications/mark_as_read.js.erb which removes the styling of an unread notification
      format.js { render 'mark_as_read' }
    end
  end
end