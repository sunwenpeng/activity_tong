ActivityTong::Application.routes.draw do
  resources :student
  get "user/show",:as => 'user_index'
  get "user/login_page"
  get "user/show_enroll_form"
  get "user/modify_password_page"
  get "user/modify_password_login_page"
  get "user/modify_password_question_page"

  get "user/admin_modify_password_page" ,:as =>'modify_password'
  get "user/admin_add_new_user"

  match 'user/admin_modify_password_page' => 'user#edit', :via => :post
  match 'user/admin_modify_password_page/:id' => 'user#edit',:via=>:post,:as=>'admin'
  match 'user/delete/:id' =>'user#destroy',:via=>:delete,:as =>'user'
  match 'user/edit/:id' => 'user#modify_password_page', :via =>:get ,:as=>'users'
  match "/user/show_enroll_form" => "user#enroll", :via => :post
  match "/user/login_page" => "user#login", :via => :post
  match "/user/modify_password_login_page" => "user#user_check", :via=> :post
  match "/user/modify_password_question_page" => "user#answer_check", :via=> :post
  match "/user/modify_password_page" => "user#update", :via=> :post
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
