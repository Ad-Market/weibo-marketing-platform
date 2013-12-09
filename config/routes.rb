WeiboMarketingPlatform::Application.routes.draw do
  get "competitor/index"

  get "follow/index"

  root :to => 'dashboard#index'
  
  # admin
  get '/admin' => "status#index"
  match '/admin/login' => "members#login"
  get '/admin/logout' => "members#logout"

  # member
  resources :members
  get 'members/:id/delete' => 'members#delete'

  # dashboard
  get "dashboard" => 'dashboard#index'
  get "get_count_of_all_users" => 'dashboard#get_count_of_all_users'

  # dashboard
  get 'login' => "dashboard#login"
  get 'logout' => "dashboard#logout"
  get 'auth' => "dashboard#auth"

  # follow
  get 'follow' => 'follow#index'
  get 'follow/follow' => 'follow#follow'
  get 'follow/unfollow' => 'follow#unfollow'

  # lbs
  get 'lbs' => 'lbs#index'
  post 'lbs/export' => 'lbs#export'

  # weibo
  get 'weibo/rate_limit' => 'weibo#rate_limit'
  get 'weibo/uid' => 'weibo#get_uid_by_name'
  get 'weibo/ajax_get_friends' => 'weibo#ajax_get_friends'
  get 'weibo/ajax_get_followers' => 'weibo#ajax_get_followers'
  get 'weibo/ajax_get_friends_latest_weibo' => 'weibo#ajax_get_friends_latest_weibo'
  get 'weibo/ajax_get_single_user_weibo' => 'weibo#ajax_get_single_user_weibo'
  get 'weibo/ajax_comment_weibo' => 'weibo#ajax_comment_weibo'
  get 'weibo/ajax_repost_weibo' => 'weibo#ajax_repost_weibo'
  get 'weibo/ajax_nearby_timeline' => 'weibo#ajax_nearby_timeline'
  get 'weibo/ajax_nearby_users' => 'weibo#ajax_nearby_users'
  get 'weibo/statuses' => 'weibo#statuses'
  
  # competitor
  get 'competitor' => 'competitor#index'
  get 'competitor/interactive_users_of_one_account' => 'weibo#interactive_users_of_one_account'
  get 'competitor/rt_interactive_users_of_one_account' => 'competitor#rt_interactive_users_of_one_account'
  get 'competitor/interactive_users_of_one_status' => 'weibo#interactive_users_of_one_status'

  # repost
  match 'repost/setting'

  #interactive
  get 'interactive' => 'interactive#index'

  #push
  get 'push' => 'push#index'


  # service
  get 'service/advanced'

  # distribution
  get "distribution" => 'distribution#index'
  get "distribution/get_count_of_users_groupby_province" => 'distribution#get_count_of_users_groupby_province'
  get "distribution/get_count_of_users_groupby_v" => 'distribution#get_count_of_users_groupby_v'
  get "distribution/get_count_of_users_groupby_gender" => 'distribution#get_count_of_users_groupby_gender'
  get "distribution/get_count_of_users_groupby_age" => 'distribution#get_count_of_users_groupby_age'

  get "status" => 'status#index'
  get "status/get_total_user_status_of_a_province" => 'status#get_total_user_status_of_a_province'
  get "status/get_daily_user_status_of_a_province" => 'status#get_daily_user_status_of_a_province'
  get "status/get_crawler_progress" => 'status#get_crawler_progress'
  get "status/get_web_cook_status_of_a_province" => 'status#get_web_cook_status_of_a_province'
  get "status/get_mobile_cook_status_of_a_province" => 'status#get_mobile_cook_status_of_a_province'
  get "status/get_disk_status" => 'status#get_disk_status'
  get "status/get_cpu_status" => 'status#get_cpu_status'
  get "status/get_rake_status" => 'status#get_rake_status'
  get "status/get_timeline_crawler_status" => 'status#get_timeline_crawler_status'
  get "status/get_repost_robot_status" => 'status#get_repost_robot_status'
  
  
  get "search" => "search#index"
  get "search/result" => "search#result"
  get "search/statistics" => "search#statistics"
  get "search/export" => "search#export"
  get "search/get_count_of_users_groupby_province" => 'search#get_count_of_users_groupby_province'
  get "search/get_count_of_users_groupby_v" => 'search#get_count_of_users_groupby_v'
  get "search/get_count_of_users_groupby_gender" => 'search#get_count_of_users_groupby_gender'
  get "search/get_count_of_users_groupby_age" => 'search#get_count_of_users_groupby_age'  
  get "search/get_export_percent" => "search#get_export_percent"
  get "search/export_dialog" => "search#export_dialog"
  get "search/generate_csv" => "search#generate_csv"


  resources :cooks
  get 'cooks/:id/delete' => 'cooks#delete'
  get 'users/export'
  get 'cities' =>  'city#index'
  resources :users  # The priority is based upon order of creation:
  # first created -> highest priority.


  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
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
