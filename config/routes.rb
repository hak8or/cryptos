Cryptos::Application.routes.draw do
  resources :fiveminute_timed_assets

  resources :timed_assets

  resources :user_infos

  require 'sidekiq/web'
  mount Sidekiq::Web, at: "/sidekiq"

  post 'NUKE', to: 'user_infos#NUKE'
  post 'start_log', to: 'staticpages#start_log'
  post 'do_old_assets_averaging', to: 'staticpages#do_old_assets_averaging'
  post 'NUKE_Averages', to: 'staticpages#NUKE_Averages'
  post 'Setup', to: 'staticpages#Setup'

  get "/homepage", to: 'staticpages#homepage'
  get "/about", to: 'staticpages#about'
  get "/database", to: 'staticpages#database'
  get "/worker_messages.html", to: 'staticpages#worker_messages'
  root 'staticpages#homepage'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
