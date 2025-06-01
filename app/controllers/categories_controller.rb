class CategoriesController < ApplicationController
  before_action :authenticate_user! #Make sure user is logged in before doing anything
  before_action :require_admin! #Make sure user is an admin
  #Call set_category before deleting or activating/deactivating a category
  before_action :set_category, only: [:destroy, :toggle_active] 
  #Function to get all categories, even deactivated ones, used to show category select list
  def index
    @categories = Category.all
  end
  #Function to create a new category in the system
  def create
    @category = Category.new(category_params) #Try to create a new category
    #If could create a category - the input params were correct then handle success
    if @category.save
      #Run the code in categories/create.js.erb which simply reload the page
      respond_to do |format|
        format.js   # renders create.js.erb
        #format.html { head :ok }
      end
    else
      #Else does nothing
      respond_to do |format|
        format.js  
        #format.html { head :unprocessable_entity }
      end
    end
  end
  #Function to delete a category, when deleting a category all posts with said category get deleted also
  def destroy
    #Destroy the found category, category is found with the set category function
    @category.destroy
    #Tries to redirect to categories/index.html.erb 
    redirect_to categories_path, notice: "Category deleted."
  end
  #Function to activate/deactivate a category, inactive categories are not shown as options for post creation
  def toggle_active
    #Update the category, since value stored is a bool, just invert it
    @category.update(active: !@category.active)
    respond_to do |format|
      format.js { head :ok }#Send back success code when request is ajax
      #Although function only called with ajax some browsers still require a format.html action
      #Tries to reload the page by going back to the state before clicking on the categories modal, if fails send user to main page
      format.html { redirect_back(fallback_location: root_path) } 
    end
  end
  private
  #Function to check if current user is an admin, if not then redirect to home page
  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
  #Function to set required parameters of category, id is added by default
  def category_params
    params.require(:category).permit(:name)
  end
  #Finds the category user is changing, only called on delete or toggling active
  def set_category
    @category = Category.find(params[:id])
  end
end
