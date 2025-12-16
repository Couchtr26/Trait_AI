Rails.application.routes.draw do
  root "chat#index"

  get "chat", to: "chat#index"
  post "chat/send_message", to: "chat#send_message"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "up" => "rails/health#show", as: :rails_health_check
end
