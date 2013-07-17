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
    # post '/reviews' => 'reviews#create'
  end

  resources :sales

  namespace :admin do 
    resources :products do 
      resources :product_categories 
      member do 
        get '/add_to_category' => 'product_category_manager#new'
        post '/category' => 'product_category_manager#join'
      end
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
  get '/categories/manage' => 'product_category_manager#new_join_many', as: 'manage_categories'
  post '/categories/manage' => 'product_category_manager#join_many', as: 'product_category_managers'
  get '/categories/:id' => 'categories#show', as: 'category'

  root to: 'products#index'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
