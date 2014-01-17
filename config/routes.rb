PhPol::Application.routes.draw do
  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "registrations"
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #root :to => "pages#index"
  root :to => "root#index"

  #resources :pages, shallow: true
  #resources :listing, shallow: true
  get '/listing', to: 'listing#index', as: :listing_index
  get '/listing/:id', to: 'listing#show', as: :listing
  get '/listing/:id/vote/:vote', to: 'listing#create_vote', as: :listing_vote_create
  post '/listing/:id/:career_id/image', to: 'listing#create_image', as: :listing_image_create

  resources :comment, only: [:show, :create, :destroy]

  #get '/users/profile/edit', to: 'users/profile#edit'
  #patch '/users/profile/save', to: 'users/profile#save'
  namespace :users do
    resources :profile, only: [:edit, :update, :show]
  end

  # utility pages
  post 'util/municipal/:id', to: 'util#municipal', as: :util_municipal
  get 'util/http_get/', to: 'util#http_get', as: :util_httpget

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
