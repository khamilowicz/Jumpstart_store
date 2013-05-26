NewStore::Application.routes.draw do

  get "orders/new"
  get "orders/create"
  get "orders/index"
  get "orders/:id" => 'orders#show', as: 'order'
  get 'orders' => 'orders#index', as: 'orders'
  get 'orders/filter/:status' => 'orders#filter', as: 'filter_orders'
  get 'orders/:id/change_status/:status' => 'orders#change_status', as: 'change_order_status'

  get "session/new"
  delete "session/delete"
  post "session/create"

  get '/products' => 'products#index'
  get '/products/new' => 'products#new', as: 'new_product'
  get '/products/:id/edit' => 'products#edit', as: 'edit_product'
  put '/products/:id' => 'products#update', as: 'product'
  post '/products' => 'products#create', as: 'products'
  get '/products/:id' => 'products#show', as: 'product'
  get '/products/:id/to_cart' => 'products#add_to_cart', as: "add_to_cart"
  get '/products/:id/remove_from_cart' => 'products#remove_from_cart', as: 'remove_from_cart'
  get '/products/:id/add_to_category' => 'products#new_add_to_category', as: 'new_add_product_to_category'
  post '/products/:id/category' => 'products#add_to_category', as: 'add_product_to_category'

  post '/products/:id/review' => 'reviews#create', as: 'product_reviews'
  put '/products/:product_id/review/:id' => 'reviews#update', as: 'product_review'
  get '/products/:product_id/review/:id/edit' => 'reviews#edit', as: 'edit_review'
  # post '/products/:product_id/review/:id/update' => 'reviews#update', as: 'update_review'


  get '/categories' => 'categories#index'
  get '/categories/:id' => 'categories#show', as: 'category'

  get '/cart' => 'carts#show', as: 'cart'

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
