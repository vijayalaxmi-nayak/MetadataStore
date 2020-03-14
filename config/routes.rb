# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api', defaults: { format: :json  } do
    namespace 'v1' do
       resources :sessions, only: [:create, :destroy] do
        resources :accounts
        resources :medias
      end
      resources :users

      get '/sessions/:session_id/show_media/:id', to: 'accounts#show_media'
      get '/sessions/:session_id/show_media_by_code/:id', to: 'accounts#show_media_by_code'
      put '/sessions/:session_id/medias/', to: 'medias#update'
    end
  end
end
