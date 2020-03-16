# frozen_string_literal: true
module Api
  module V1
    class AccountsController < ApplicationController
      # displays the data of all the accounts
      api :GET, '/sessions/:session_id/accounts/', 'Fetch all the account details'
      param :session_id, String, desc: 'Session Id'
      example %(
      GET /api/v1/sessions/pvVSdt9Q2f9up4fa5AQV/accounts
      {
      "status": "SUCCESS",
      "message": "Loaded accounts",
      "data": [
      {
        "id": 18,
        "code": "Account11",
        "name": "new-account",
        "password": "Account11",
        "created_at": "2020-03-14T12:36:37.000Z",
        "updated_at": "2020-03-14T12:48:50.000Z",
        "user_id": 1
      }]
      }
      )
      def index
        current_user = User.find_by_authentication_token(params[:session_id])
        accounts = current_user.accounts.all
        render json: { status: 'SUCCESS', message: 'Loaded accounts', data:
 accounts }, status: :ok
      end

      # displays the details of specific account based on the id
      api :GET, '/sessions/:session_id/accounts/:id', 'Fetches the specific account based on id'
      param :session_id, String, desc: 'Session Id'
      param :id, :number, desc: 'Id'
      example %(
      GET /api/v1/sessions/pvVSdt9Q2f9up4fa5AQV/accounts/1
      {
      "status": "SUCCESS",
      "message": "Loaded account",
      "data": {
        "id": 1,
        "code": "PQR100",
        "name": "Account1",
        "password": "Account1",
        "created_at": "2020-02-25T14:00:01.000Z",
        "updated_at": "2020-02-25T14:08:55.000Z",
        "user_id": 1
      }
      }
      )
      def show
        current_user = User.find_by_authentication_token(params[:session_id])
        account = current_user.accounts.find(params[:id])
        #account = Account.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded account', data:
account }, status: :ok
      end

      # creates a new account
      api :POST, '/sessions/:session_id/accounts/', 'Creates a new account'
      param :session_id, String, desc: 'Session Id'
      param :code, String, desc: 'Code', required: true
      param :name, String, desc: 'Name', required: true
      param :password, String, desc: 'Password', required: true
      example %(
      POST /api/v1/sessions/pvVSdt9Q2f9up4fa5AQV/accounts
      Input:
      {
      "code":"SDA100",
      "name":"Account11",
      "password":"Account11"
      }

      Server response:
      {
      "status": "SUCCESS",
      "message": "Saved account",
      "data": {
        "id": 14,
        "code": "SDA100",
        "name": "Account11",
        "password": "Account11",
        "created_at": "2020-03-02T10:24:09.000Z",
        "updated_at": "2020-03-02T10:24:09.000Z",
        "user_id": 1
      }
      }
      )
      def create
        current_user = User.find_by_authentication_token(params[:session_id])
        if current_user != nil
          account = Account.new({name: params[:name], code: params[:code], password: params[:password], user_id: current_user.id})
          if account.save
            render json: { status: 'SUCCESS', message: 'Saved account', data:
  account }, status: :ok
          else
            render json: { status: 'ERROR', message: 'Account not saved', data:
  account.errors }, status: :unprocessable_entity
          end
        end
      end

      # deletes a specific account based on the id
      api :DELETE, '/sessions/:session_id/accounts/:id', 'Deletes a specific account by id'
      param :session_id, String, desc: 'Session Id'
      param :id, :number, desc: 'Id'
      example %(
      DELETE api/v1/sessions/pvVSdt9Q2f9up4fa5AQV/accounts/14
      {
      "status": "SUCCESS",
      "message": "Deleted account",
      "data": {
        "id": 14,
        "code": "SDA100",
        "name": "Account11",
        "password": "Account11",
        "created_at": "2020-03-02T10:24:09.000Z",
        "updated_at": "2020-03-02T10:24:09.000Z",
        "user_id": 1
      }
      }
      )
      def destroy
        current_user = User.find_by_authentication_token(params[:session_id])
        if current_user != nil
          account = Account.find(params[:id])
          account.destroy
          render json: { status: 'SUCCESS', message: 'Deleted account', data:
  account }, status: :ok
        end
      end

      # updates a specific account based on the id
      api :PUT, '/sessions/:session_id/accounts/:id', 'Updates a specfic account by id'
      param :session_id, String, desc: 'Session Id'
      param :id, :number, desc: 'Id'
      param :code, String, desc: 'Code'
      param :name, String, desc: 'Name'
      param :password, String, desc: 'Password'
      example %(
      PUT api/v1/sessions/pvVSdt9Q2f9up4fa5AQV/accounts/13
      Input:
      {
      "code":"SDA100",
      "name":"Account13",
      "password":"Account13"
      }

      Server response:
      {
      "status": "SUCCESS",
      "message": "Updated account",
      "data": {
        "id": 13,
        "code": "SDA100",
        "name": "Account13",
        "password": "Account13",
        "created_at": "2020-02-28T09:15:52.000Z",
        "updated_at": "2020-03-02T10:33:47.000Z",
        "user_id": 1
      }
      }
      )
      def update
        current_user = User.find_by_authentication_token(params[:session_id])
        if current_user != nil
          account = Account.find(params[:id])
          if account.update_attributes(params_account)
            render json: { status: 'SUCCESS', message: 'Updated account', data:
  account }, status: :ok
          else
            render json: { status: 'ERROR', message: 'Account not updated', data:
  account.errors }, status: :unprocessable_entity
          end
        end
      end

      # displays medias(audios/videos) of specific account based on the id
      api :GET, '/sessions/:session_id/show_media/:id', 'Displays medias(audios or videos) of
specific account based on id'
      param :session_id, String, desc: 'Session Id'
      param :id, :number, desc: 'Id'
      example %(
      GET api/v1/sessions/pvVSdt9Q2f9up4fa5AQV/show_media/2
      {
      "status": "SUCCESS",
      "message": "Loaded media",
      "data": [
      {
        "asset_id": "AB100",
        "media_type": "audio",
        "account_id": 2,
        "title": null,
        "duration": null,
        "location": null,
        "recorded_time": null,
        "timecode": null,
        "created_at": "2020-02-28T09:12:47.000Z",
        "updated_at": "2020-02-28T09:12:47.000Z"
      },
      {
        "asset_id": "AC100",
        "media_type": "audio",
        "account_id": 2,
        "title": null,
        "duration": null,
        "location": null,
        "recorded_time": null,
        "timecode": null,
        "created_at": "2020-02-28T09:49:48.000Z",
        "updated_at": "2020-02-28T09:49:48.000Z"
      }
      ]
      }
      )
      def show_media
        current_user = User.find_by_authentication_token(params[:session_id])
        if current_user != nil
          account = Account.find(params[:id])
          medias = account.medias.all
          render json: { status: 'SUCCESS', message: 'Loaded media', data: medias
  }, status: :ok
        end
      end

      # displays medias(audios/videos) of specific account based on the account
      # code
      api :GET, '/sessions/:session_id/show_media_by_code/:id', 'Displays medias(audios or videos) of
specific account based on code'
      param :session_id, String, desc: 'Session Id'
      param :id, String, desc: 'Code'
      example %(
      GET api/v1/sessions/pvVSdt9Q2f9up4fa5AQV/show_media_by_code/XYZ100
      {
      "status": "SUCCESS",
      "message": "Loaded media",
      "data": [
      {
        "asset_id": "AB100",
        "media_type": "audio",
        "account_id": 2,
        "title": null,
        "duration": null,
        "location": null,
        "recorded_time": null,
        "timecode": null,
        "created_at": "2020-02-28T09:12:47.000Z",
        "updated_at": "2020-02-28T09:12:47.000Z"
      },
      {
        "asset_id": "AC100",
        "media_type": "audio",
        "account_id": 2,
        "title": null,
        "duration": null,
        "location": null,
        "recorded_time": null,
        "timecode": null,
        "created_at": "2020-02-28T09:49:48.000Z",
        "updated_at": "2020-02-28T09:49:48.000Z"
      }
      ]
      }
      )
      def show_media_by_code
        current_user = User.find_by_authentication_token(params[:session_id])
        if current_user != nil
          account = Account.find_by_code(params[:id])
          medias = account.medias.all
          render json: { status: 'SUCCESS', message: 'Loaded media', data: medias
  }, status: :ok
        end
      end

      private

      def params_account
        params.permit(:code, :name, :password)
      end
    end
  end
end
