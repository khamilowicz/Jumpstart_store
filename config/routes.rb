NewStore::Application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]

  get 'search' => 'search#new', as: 'search'
  post 'search' => 'search#show', as: 'searches'
  post 'search_product' => 'search#new_product', as: 'search_product'

  resources :orders, except: [:create] do 
    collection do
      post '/create' => "orders#create", as: 'create'
      get '/filter' => 'orders#filter', as: 'filter'
      post '/new' => 'orders#new'
    end
    get '/change_status' => 'orders#change_status', as: 'change_status'
  end
  
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:edit, :update, :create]
  end

  resources :sales

  namespace :admin do 
    resources :types
    resources :products do 
      # resources :product_categories 
      # member do 
      #   get '/add_to_category' => 'product_category_manager#new'
      #   post '/category' => 'product_category_manager#join'
      # end
    end
  end

  get '/cart' => 'carts#show'


  resources :users do 
    member do
      get '/cart' => 'carts#show', as: 'cart'
    end
  end

  get 'add_to_cart' => 'product_cart_manager#join' 
  get 'remove_from_cart' => 'product_cart_manager#destroy'

  get '/categories' => 'categories#index'
  # get '/categories/manage' => 'product_category_manager#new_join_many', as: 'manage_categories'
  # post '/categories/manage' => 'product_category_manager#join_many', as: 'product_category_managers'
  get '/categories/:id' => 'categories#show', as: 'category'

  root to: 'products#index'

end
