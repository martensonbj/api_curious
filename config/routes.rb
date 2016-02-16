Rails.application.routes.draw do
  get '/dashboard', to: "users#show"
  root "home#show"
  get '/auth/:provider/callback', to: 'sessions#create'
end
