#Overrides devise session controller
class Users::SessionsController < Devise::SessionsController
  #Define that controller can respond with js also, used because only using this for ajax in login modal
  respond_to :js
  #Function to handle login, try to auth user, if success reload page to show updated view, else show error
  def create
    #Use warden with devise helper to try login user with provided email and password
    self.resource = warden.authenticate(auth_options)
    #If login was successful, as in credentials were valid, login user, create the session and reload the page to show updated user view
    if resource
      #Login user into their account, and create session with their user saved
      sign_in(resource_name, resource)
      #Reload page to show updates view with authenticated user buttons/gui elements
      render js: "window.location.reload();"
    else
      #Otherwise select the div for login modal elements and set its content to the error message - doing this way because only need 1 type of error message
      render js: "document.getElementById('loginModalErrors').innerHTML = '<div class=\"alert alert-warning\">Invalid email or password</div>';"
    end
  end
end