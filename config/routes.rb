Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # Merchant Endpoints
  get "/api/v1/merchants", to: "api/v1/merchants#index"

  post "/api/v1/merchants", to: "api/v1/merchants#create"
  patch "/api/v1/merchants/:id", to: "api/v1/merchants#update"

  #MerchantsCustomers
  get "/api/v1/merchants/:merchant_id/customers", to: "api/v1/merchants_customers#index"

  # Item Endpoints
  get "/api/v1/items", to: "api/v1/items#index"
  post "/api/v1/items", to: "api/v1/items#create"
  patch "/api/v1/items/:id", to: "api/v1/items#update"
  put "/api/v1/items/:id", to: "api/v1/items#update"
  get "/api/v1/merchants/:id", to: "api/v1/merchants#show"
  get "/api/v1/items/:id", to: "api/v1/items#show"
  #relationship endpoints
  get "/api/v1/merchants/:id/items", to: "api/v1/merchant_items#index"
  get "/api/v1/items/:id/merchant", to: "api/v1/item_merchants#show"
end
