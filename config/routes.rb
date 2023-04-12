Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'users/registrations'}
  get '/referral-only', to: 'referral_only#index', as: :referral_only
  post '/send-referral', to: 'home#send_invitation'
  root 'home#index'
end
