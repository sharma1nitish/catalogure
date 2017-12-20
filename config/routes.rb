Rails.application.routes.draw do
  root 'products#index'

  get 'products/filter', to: 'products#filter'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
