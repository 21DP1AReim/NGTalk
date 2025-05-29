Rails.application.routes.draw do
  match '*path', via: :options, to: ->(_) { [204, { 'Content-Type' => 'text/plain' }] }
  
  root 'pages#main_page'
  get 'main_page', to: 'pages#main_page'
  
  resources :notifications, only: [:destroy] do
    patch :mark_as_read, on: :member
    
  end

  resources :categories, only: [:index, :create, :destroy] do
    patch :toggle_active, on: :collection
  end


  resources :posts do
    member do
      delete :purge #For deleting archived posts
      patch :restore #For unarchiving posts
    end
    collection do
      get :new_article
      post :create_article
      get :new_post
      post :create_post
      get :search
    end
  

    resources :comments, only: [:create, :index, :destroy] do
      member do
        get :reply  # For nested replies, used for when calls a fetch by reply button click
      end
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  resources :users, only: [], controller: 'users' do
    get 'activity', on: :collection
  end

  # Static pages
  get 'stylesheet', to: 'pages#stylesheet'
  get 'postStyle', to: 'posts#stylesheet'
  get 'NGTalkLogo', to: 'pages#g'
  get 'search', to: 'search#index'
  get '/make_post', to: 'pages#make_post_page', as: 'make_post_page'
  post '/create_post', to: 'pages#create_post'

end