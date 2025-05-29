class NotificationsController < ApplicationController
  def mark_as_read
    note = current_user.notifications.find(params[:id])
    note.update(read_at: Time.current)
    head :ok
  end

  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_path, notice: 'Notification removed' }
      format.js   # Will look for app/views/notifications/destroy.js.erb
    end
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.update(read_at: Time.current)
    respond_to do |format|
      format.js { render 'mark_as_read' }
    end
  end
end