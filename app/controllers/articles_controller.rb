class ArticlesController < ApplicationController
  load_and_authorize_resource

  def show
    @article = Article.find(params[:id])
    @author = User.find(@article.author)
    @commentable = @article
    @comments = @commentable.comments.includes(:user).order("created_at DESC")
    @comment = Comment.new
  end

  def new
    @article = Article.new
    @article.author = current_user.id
  end

  def create
    @article = Article.new(article_params)
    @article.author = current_user.id
    if @article.save
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html { render 'edit' }
      format.js { render layout: false }
    end
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    @search = Article.ransack(params[:search])
    @article = @search.result(distinct: true)
    render 'index'
  end

def index
  if params[:sort_by].present?
    @article = case params[:sort_by]
      when 'title_asc'
        Article.order(title: :asc)
      when 'title_desc'
        Article.order(title: :desc)
      when 'replies_asc'
        Article
          .left_joins(:comments, :replies)
          .select("articles.*, COUNT(DISTINCT comments.id) + COUNT(DISTINCT replies.id) AS total_count")
          .group("articles.id")
          .order("total_count ASC")
      when 'replies_desc'
        Article
          .left_joins(:comments, :replies)
          .select("articles.*, COUNT(DISTINCT comments.id) + COUNT(DISTINCT replies.id) AS total_count")
          .group("articles.id")
          .order("total_count DESC")
      when 'activity_asc'
        Article.order(updated_at: :asc)
      when 'activity_desc'
        Article.order(updated_at: :desc)
      else
        Article.all
      end
  else
    @article = Article.order(updated_at: :desc)
  end

  @article = @article.page(params[:page]).per(18)

  respond_to do |format|
    format.html
    format.js { render partial: 'sorted_posts', locals: { posts: @article } }
  end
end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  private
    def article_params
      params.require(:article).permit(:title, :text, :author)
    end
  end

