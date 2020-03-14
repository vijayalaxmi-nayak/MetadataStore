module Api
  module V1
    class SessionsController < ApplicationController
      #signin
      api :POST, '/sessions', 'Signin by the user'
      param :email, String, desc: 'Email Id', required: true
      param :password, String, desc: 'Password', required: true
      example %(
      POST /api/v1/sessions
      Input:
      {
      "email":"vijayalaxmi@gmail.com",
      "password":"12345678"
      }

      Server response:
      {
      "message": "Success",
      "id": 1,
      "email": "vijayalaxmi@gmail.com",
      "authentication_token": "pvVSdt9Q2f9up4fa5AQV"
      }
      )
      def create
        user = User.where(email: params[:email]).first
        if user&.valid_password?(params[:password])
          render json: { message: 'Success', id: user.id, email: user.email, authentication_token: user.authentication_token }, status: :ok
        else
          head(:unauthorized)
        end
      end

      #signout
      api :DELETE, '/sessions/:session_id', 'Signin by the user'
      param :id, String, desc: 'Session Id'
      example %(
      DELETE /api/v1/sessions/YeVzzYo5pcxp_M8Uzz9x
      )
      def destroy
        current_user = User.where(authentication_token: params[:id]).first
        current_user&.authentication_token = nil
        if current_user.save
          head(:ok)
        else
          head(:unauthorized)
        end
      end
    end
  end
end
