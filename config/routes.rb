Rails.application.routes.draw do
  match '*path', via: :options, to: ->(_) { [204, { 'Content-Type' => 'text/plain' }] }
  get 'main_page', to: 'pages#main_page'
  root 'pages#main_page'

  resources :articles

  resources :comments do
    resources :replies, only: [:new, :create, :destroy], controller: 'replies' do
      resources :replies, only: [:new, :create, :destroy], controller: 'replies'
    end
  end

  resources :posts do
    collection do
      get :search
    end
    resources :comments, only: [:index, :create, :destroy]
  end

  get 'stylesheet', to: 'pages#stylesheet'
  get 'postStyle', to: 'posts#stylesheet'
  get 'g', to: 'pages#g'
  get 'search', to: 'search#index'
  get '/make_post', to: 'pages#make_post_page', as: 'make_post_page'
  post '/create_post', to: 'pages#create_post'

  devise_for :users

  # You only need to define this once
  resources :articles, only: [] do
    resources :comments, only: [:create]
  end
end