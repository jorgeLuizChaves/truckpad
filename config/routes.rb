Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :drivers, only: [:index, :show, :update, :create, :destroy]

  resources :drivers do
    resources :trucks, only: [:index, :create, :update]
    resources :driver_licenses, only: [:index, :create, :update], :path => "licenses"
  end
end
