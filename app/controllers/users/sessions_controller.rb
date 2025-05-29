class Users::SessionsController < Devise::SessionsController
  respond_to :html, :js

  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      sign_in(resource_name, resource)
      render js: "window.location.reload();"
    else
      render js: "document.getElementById('loginModalErrors').innerHTML = '<div class=\"alert alert-warning\">Invalid email or password</div>';"
    end
  end
end