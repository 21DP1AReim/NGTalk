Rails.application.routes.draw do
  match '*path', via: :options, to: ->(_) { [204, { 'Content-Type' => 'text/plain' }] }
  
  root 'pages#main_page'
  get 'main_page', to: 'pages#main_page'
  
  resources :posts do
    collection do
      get :new_article
      post :create_article
      get :new_post
      post :create_post
      get :search
    end
    
    resources :comments, only: [:create, :index, :destroy] do
      member do
        get :reply  # For nested replies
      end
    end
  end

  devise_for :users
  resources :users, only: [], controller: 'users' do
    get 'activity', on: :collection
  end

  # Static pages
  get 'stylesheet', to: 'pages#stylesheet'
  get 'postStyle', to: 'posts#stylesheet'
  get 'g', to: 'pages#g'
  get 'search', to: 'search#index'
  get '/make_post', to: 'pages#make_post_page', as: 'make_post_page'
  post '/create_post', to: 'pages#create_post'

end