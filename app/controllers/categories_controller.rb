class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_category, only: [:destroy, :toggle_active]

  def index
    @categories = Category.all
  end

  def create
    @category = Category.new(category_params)
  
    if @category.save
      respond_to do |format|
        format.js   # renders create.js.erb
        format.html { head :ok }
        format.json { render json: @category, status: :created }
      end
    else
      respond_to do |format|
        format.js   # you can handle errors in JS too
        format.html { head :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def destroy
    
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path, notice: "Category deleted."
  end

  def toggle_active
  
    @category = Category.find(params[:id])
    @category.update(active: !@category.active)
    
  respond_to do |format|
    format.js { head :ok }  # No content, just HTTP 200 for AJAX
    format.html { redirect_back(fallback_location: root_path) }  # fallback for normal requests
  end
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

end
