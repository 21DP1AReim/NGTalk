class ApplicationController < ActionController::Base
  #Throw an exception when catching a CRSF(cross site request forgery) error
  protect_from_forgery with: :exception
  #Calls the configure permited params function everytime a devise action is handled, which in this projects case is signup and login
  before_action :configure_permitted_parameters, if: :devise_controller?
  #When a user tries to do something he doesnt have access to, send them to home page, and save the exception message in flashdata
  #Should not get called unless user tries to specifically break something, as every functionality has specfic checks just to show the option
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
  protected
  #Function change the allowed parameters for devise, by default only allows email and password
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_name, :email, :password, :password_confirmation])
  end
end