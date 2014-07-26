Ovks::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'bills#index'

  resources :bills do
    resources :bill_positions
    # get 'bills' => 'bills#index', as: 'bills'
    # get 'bills/new' => 'bills#new', as: 'new_bill'
    # get 'bills/:id' => 'bills#show', as: 'bill'
    # get 'bills/:id/edit' => 'bills#edit', as: 'edit_bill'
    # post 'bills' => 'bills#create'
    # patch 'bills/:id' => 'bills#update'
    # delete 'bills/:id' => 'bills#destroy'
  end

  controller :sessions do
    get 'login' => 'sessions#login', as: 'login'
    get 'logout' => 'sessions#destroy', as: 'logout'
    post 'login' => 'sessions#create'
  end

  resources :szs do
    collection do
      get 'not_done'
    end
  end
  resources :nzs do
    collection do
      get 'not_done'
    end
  end
  resources :items, except: [:index, :new, :show]
  resources :employees, except: [:show]
  resources :departments, except: [:index, :show]
  resources :types, except: [:show]
  resources :vendors, except: [:show, :delete]
  resources :receipts

  get "search" => 'search#search', as: 'search'

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
