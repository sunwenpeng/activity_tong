ActivityTong::Application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  get 'user/show/synchronously_show' => 'user#synchronously_show'
  get 'user/login_page'
  get "user_enroll/show_enroll_form"
  get "user_modify_password/modify_password_page"
  get "user_modify_password/modify_password_login_page"
  get "user_modify_password/modify_password_question_page"
  get "user/show/admin_add_new_user" => 'admin#admin_add_new_user'
  get 'user/show/:id/admin_modify_password_page' => 'admin#admin_modify_password_page'
  get 'user/show/logout' => 'user#logout'
  get 'user/show/:id/logout' => 'user#logout'
  get 'user/show/:id/:name/logout' => 'user#logout'
  get 'user/show/:id' => 'user#show', :as => 'user_index'
  get 'bid/bid_list'
  get 'user/show/:id/:name' => 'bid#bid_list' ,:as => 'bids'
  get 'user/show/:id/:name/sign_up_list' => 'sign_up#sign_up_list', :as =>'sign_ups'
  get 'user/show/:id/:name/:bid_name' => 'bid#bid_detail_list' , :as => 'bid_detail'
  get 'user/admin_show_user/:id/logout' => 'user#logout'
  get 'user/admin_show_user/:id/:user_name' => 'user#show' ,:as=> 'show_user'


  post 'phone_customer/customer_check'
  post 'phone_customer/customer_data_update'

  match 'user/show/:id/admin_modify_password_page' => 'admin#edit', :via=> :post,:as=>'admin'
  match 'user/delete/:id' =>'user#destroy',:via=>:delete,:as =>'user'
  match "user_enroll/show_enroll_form" => "user_enroll#enroll", :via => :post
  match "/user/login_page" => "user#login", :via => :post
  match "/user_modify_password/modify_password_login_page" => "user_modify_password#user_check", :via=> :post
  match "/user_modify_password/modify_password_question_page" => "user_modify_password#answer_check", :via=> :post
  match "/user_modify_password/modify_password_page" => "user_modify_password#update", :via=> :post
  match '/user/show/admin_add_new_user' => 'admin#adminAddNewUser', :via => :post





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