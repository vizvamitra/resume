Musgroups::Application.routes.draw do

  root 'groups#index', as: 'index', via: :all

  get '/task' => 'task#task', as: 'task'

  controller :search do
    get "search" => :index, as: 'search'
    post "search" => :index
  end

  resources :groups

  controller :songs do
    get '/groups/:group_id/songs' => :index, as: 'group_songs'
    get '/groups/:group_id/songs/new' => :new, as: 'new_group_song'
    get '/groups/:group_id/songs/:id/edit' => :edit, as: 'edit_group_song'
    post '/songs' => :create, as: 'songs'
    patch '/songs/:id' => :update, as: 'song'
    delete '/songs/:id' => :destroy
  end

  controller :members do
    get '/groups/:group_id/members' => :index, as: 'group_members'
    get '/groups/:group_id/members/new' => :new, as: 'new_group_member'
    get '/groups/:group_id/members/:id/edit' => :edit, as: 'edit_group_member'
    post '/members' => :create, as: 'members'
    patch '/members/:id' => :update, as: 'member'
    delete '/members/:id' => :destroy
  end

  controller :tours do
    get '/groups/:group_id/tours' => :index, as: 'group_tours'
    get '/groups/:group_id/tours/:id/concerts' => :show, as: 'group_tour'
    get '/groups/:group_id/tours/:id/edit' => :edit, as: 'edit_group_tour'
    get '/groups/:group_id/tours/new' => :new, as: 'new_group_tour'
    post '/tours' => :create, as: 'tours'
    patch '/tours/:id' => :update, as: 'tour'
    delete '/tours/:id' => :destroy
  end

  controller :concerts do
    get '/groups/:group_id/tours/:tour_id/concerts/:id/edit' => :edit, as: 'edit_tour_concert'
    get '/groups/:group_id/tours/:tour_id/concerts/new' => :new, as: 'new_tour_concert'
    post '/concerts' => :create, as: 'concerts'
    patch '/concerts/:id' => :update, as: 'concert'
    delete '/concerts/:id' => :destroy
  end

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
