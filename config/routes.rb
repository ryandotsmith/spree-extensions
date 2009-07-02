map.namespace :admin do |admin|
  admin.resources :discount_codes
  admin.resources :reports, :only => [:index, :show], 
                            :collection => {  :sales_total => :get, 
                                              :discount_codes => :get,
                                              :discount_code_orders => :get
                                            }
end