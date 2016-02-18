Rails.application.routes.draw do
  # get 'admin/index'
  # get 'sessions/new'
  # get 'sessions/create'
  # get 'sessions/destroy'

  # get 'admin' => 'admin#index'
  # controller :sessions do
  #   get 'login' => :new
  #   post 'login' => :create
  #   delete 'logout' => :destroy
  #
  # end

  #root 'adventurers#index'
  root to: 'application#index'
  resources :adventurers
  resources :events
  resources :facilities
  resources :guild
  resources :guildmaster
  resources :quests
  resources :accounts
  resources :sessions
  resources :guildsessions
end

#constraints subdomain: 'api' do
# namespace :api do
# namespace :api, defaults: { format: :json },
#     constraints: { subdomain: 'api' }, path: '/'  do
# scope module: :v1,
#As for now version 1 is the default,
#so every request will be redirected to that version,
# no matter if the header with the version is present or not.
#    constraints: ApiConstraints.new(version: 1, default: true) do





#get 'welcome/index'
#get '/adventurers/:hp', to: 'adventurer#show', as: 'adventurer'
#get '/adventurers/:id', to: 'adventurer#new'




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