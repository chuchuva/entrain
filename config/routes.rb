Rails.application.routes.draw do

  get 'users/new'

  get 'programs/:id', to: 'programs#show', as: :program

  root 'programs#index'

  get    'login'   => 'session#new'
  post   'login'   => 'session#create'
  delete 'logout'  => 'session#destroy'
  get    'signup'  => 'users#new'
  post   '/users'  => 'users#create'
  post   '/users/ontraport'    => 'users#create_from_ontraport'
  get    '/users/set-password' => 'users#set_password'
  post   '/users/set-password' => 'users#set_password'
  resources :account_activations, only: [:edit, :update]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  get    'purchase/thank-you' => 'orders#thank_you'
  get    'purchase/:program_id', to: 'orders#new', as: :new_order
  post   'purchase/:program_id', to: 'orders#create', as: :orders
  get    'purchase/:program_id/paypal-confirm' => 'orders#paypal_confirm',
            as: :paypal_confirm
  get    'purchase/:program_id/bank-transfer-instructions',
            to: 'orders#bank_transfer_instructions', as: :bank_transfer_instructions

  namespace :admin do
    resources :programs, shallow: true do
      resources :pages
      resources :texts
      resources :emails, as: 'email_templates', controller: 'email_templates'
    end
    resources :settings
    get 'test-email', to: 'test_email#new'
    post 'test-email', to: 'test_email#send_email'
  end
  resources :invites
  get 'admin/invites/show/:id' => 'invites#show_admin'
  get ':program_slug/:page_slug/:id', to: 'pages#show', as: :page

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
