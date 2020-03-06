# frozen_string_literal: true
Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      resources :accounts
      resources :medias
      resources :audios
      resources :videos

      get '/show_media/:id', to: 'accounts#show_media'
      get '/show_media_by_code/:id', to: 'accounts#show_media_by_code'
      put '/medias/', to: 'medias#update'
    end
  end
end
