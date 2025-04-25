Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  #non RESTful endpoints
  get "/api/v1/merchants/find", to: "api/v1/merchants#find"
  get "/api/v1/items/find", to: "api/v1/items_search#find"
  get "/api/v1/items/find_all", to: "api/v1/items_search#find_all"

  # Merchant Endpoints
  get "/api/v1/merchants", to: "api/v1/merchants#index"
  get "/api/v1/items", to: "api/v1/items#index"
  get "/api/v1/merchants/:id", to: "api/v1/merchants#show"
  post "/api/v1/merchants", to: "api/v1/merchants#create"
  patch "/api/v1/merchants/:id", to: "api/v1/merchants#update"
  delete "/api/v1/merchants/:id", to: "api/v1/merchants#destroy"
 
  # Item Endpoints
  get "/api/v1/items", to: "api/v1/items#index"
  get "/api/v1/items/:id", to: "api/v1/items#show"
  post "/api/v1/items", to: "api/v1/items#create"
  patch "/api/v1/items/:id", to: "api/v1/items#update"
  put "/api/v1/items/:id", to: "api/v1/items#update"
  delete "/api/v1/items/:id", to: "api/v1/items#destroy"
  
  #relationship endpoints
  get "/api/v1/merchants/:id/items", to: "api/v1/merchant_items#index"
  get "/api/v1/items/:id/merchant", to: "api/v1/item_merchants#show"
  get "/api/v1/merchants/:merchant_id/invoices", to: "api/v1/invoices#index"
  get "/api/v1/merchants/:merchant_id/customers", to: "api/v1/merchants_customers#index"

  #Coupon Endpoints
  namespace :api do
    namespace :v1 do 
      resources :merchants, only: [] do
        resources :coupons, only: [:index,:show,:create]
      end
    end
  end

  patch "/api/v1/merchants/:merchant_id/coupons/:id", to: "api/v1/coupons#update"
 
end
