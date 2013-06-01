NewStore::Application.routes.draw do

  get '/dashboard' => 'admins#dashboard', as: "admin_dashboard"

  get '/sales/new' => 'sales#new', as: "new_sale"
  delete '/sales' => 'sales#delete', as: "sales"
  get '/sales' => 'sales#index', as: 'sales'
  post '/sales' => 'sales#create'

  get 'session/new' => 'session#new', as: 'new_session'
  post 'session/create' => 'session#create', as: 'sessions'
  delete 'session/delete' => 'session#delete', as: 'session'
  # get 'sales/new'
  # post 'sales/create'
  # get 'sales' => 'sales#index'
  # delete 'sales' => 'sales#delete'

  # get 'orders' => 'orders#index', as: 'orders'
  # get 'products' => 'products#index', as: 'products'
  # get 'orders/create' => 'orders#create', as: 'create'

  resources :orders, except: [:create] do 
    collection do
      get '/create' => "orders#create", as: 'create'
      get '/filter' => 'orders#filter', as: 'filter'
    end
    get '/change_status' => 'orders#change_status', as: 'change_status'
  end
  
  resources :products do
    get '/add_to_category' => 'product_category_manager#new'
    post '/category' => 'product_category_manager#join'
    resources :reviews, only: [:edit, :update]
    post '/reviews' => 'reviews#create'
  end

  get '/cart' => 'carts#show'
  
  resources :users do 
    member do
      get '/cart' => 'carts#show', as: 'cart'
    end
    resources :products, only: [] do 
      member do 
        get 'add_to_cart' => 'product_cart_manager#join' 
        get 'remove_from_cart' => 'product_cart_manager#destroy' 
      end
    end
  end


  get '/categories' => 'categories#index'
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
