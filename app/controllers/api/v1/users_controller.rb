module Api
  module V1
    class UsersController < ApplicationController
      api :POST, '/users', 'Creates a new user'
      example %(
      POST /api/v1/users
      Input:
      {
      "user":{
      "email":"vijayalaxmi@gmail.com",
      "password":"123456789",
      "password_confirmation":"123456789"
      }
      }

      Server response:
      {
      "status": "SUCCESS",
      "message": "Created user",
      "data": {
        "id": 3,
        "email": "vijayalaxmi@gmail.com",
        "created_at": "2020-03-14T11:20:06.000Z",
        "updated_at": "2020-03-14T11:20:06.000Z",
        "authentication_token": "ReiZyaAsf45ytMrw6Tw7"
      }
      }
      )
      def create
        user = User.new(user_params)
        if user.save
          render json: { status: 'SUCCESS', message: 'Created user', data:
user }, status: :ok
        else
          render json: { status: 'ERROR', message: 'User info not saved', data:
user.errors }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end

