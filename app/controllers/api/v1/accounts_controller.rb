# frozen_string_literal: true
module Api
  module V1
    class AccountsController < ApplicationController
      # displays the data of all the accounts
      api :GET, '/accounts/', 'Fetch all the account details'
      example %(
      GET /api/v1/accounts
      {
      "status": "SUCCESS",
      "message": "Loaded accounts",
      "data": [
        {
          "id": 1,
          "code": "PQR100",
          "name": "Account1",
          "password": "Account1",
          "created_at": "2020-02-25T14:00:01.000Z",
          "updated_at": "2020-02-25T14:08:55.000Z"
        },
        {
          "id": 2,
          "code": "XYZ100",
          "name": "Account2",
          "password": "Account2",
          "created_at": "2020-02-25T14:00:19.000Z",
          "updated_at": "2020-02-25T14:00:19.000Z"
        }
      ]
      }
      )
      def index
        accounts = Account.all
        render json: { status: 'SUCCESS', message: 'Loaded accounts', data:
 accounts }, status: :ok
      end

      # displays the details of specific account based on the id
      api :GET, '/accounts/:id', 'Fetches the specific account based on id'
      param :id, :number, desc: 'Id'
      example %(
      GET /api/v1/accounts/1
      {
      "status": "SUCCESS",
      "message": "Loaded account",
      "data": {
        "id": 1,
        "code": "PQR100",
        "name": "Account1",
        "password": "Account1",
        "created_at": "2020-02-25T14:00:01.000Z",
        "updated_at": "2020-02-25T14:08:55.000Z"
      }
      }
      )
      def show
        account = Account.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Loaded account', data:
account }, status: :ok
      end

      # creates a new account
      api :POST, '/accounts/', 'Creates a new account'
      param :code, String, desc: 'Code', required: true
      param :name, String, desc: 'Name', required: true
      param :password, String, desc: 'Password', required: true
      example %(
      POST /api/v1/accounts
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
        "updated_at": "2020-03-02T10:24:09.000Z"
      }
      }
      )
      def create
        account = Account.new(params_account)
        if account.save
          render json: { status: 'SUCCESS', message: 'Saved account', data:
account }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Account not saved', data:
account.errors }, status: :unprocessable_entity
        end
      end

      # deletes a specific account based on the id
      api :DELETE, '/accounts/:id', 'Deletes a specific account by id'
      param :id, :number, desc: 'Id'
      example %(
      DELETE api/v1/accounts/14
      {
      "status": "SUCCESS",
      "message": "Deleted account",
      "data": {
        "id": 14,
        "code": "SDA100",
        "name": "Account11",
        "password": "Account11",
        "created_at": "2020-03-02T10:24:09.000Z",
        "updated_at": "2020-03-02T10:24:09.000Z"
      }
      }
      )
      def destroy
        account = Account.find(params[:id])
        account.destroy
        render json: { status: 'SUCCESS', message: 'Deleted account', data:
account }, status: :ok
      end

      # updates a specific account based on the id
      api :PUT, '/accounts/:id', 'Updates a specfic account by id'
      param :id, :number, desc: 'Id'
      param :code, String, desc: 'Code'
      param :name, String, desc: 'Name'
      param :password, String, desc: 'Password'
      example %(
      PUT api/v1/accounts/13
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
        "updated_at": "2020-03-02T10:33:47.000Z"
      }
      }
      )
      def update
        account = Account.find(params[:id])
        if account.update_attributes(params_account)
          render json: { status: 'SUCCESS', message: 'Updated account', data:
account }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Account not updated', data:
account.errors }, status: :unprocessable_entity
        end
      end

      # displays medias(audios/videos) of specific account based on the id
      api :GET, '/show_media/:id', 'Displays medias(audios or videos) of
specific account based on id'
      param :id, :number, desc: 'Id'
      example %(
      GET api/v1/show_media/2
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
        account = Account.find(params[:id])
        medias = account.medias.all
        render json: { status: 'SUCCESS', message: 'Loaded media', data: medias
}, status: :ok
      end

      # displays medias(audios/videos) of specific account based on the account
      # code
      api :GET, '/show_media_by_code/:id', 'Displays medias(audios or videos) of
specific account based on code'
      param :id, String, desc: 'Code'
      example %(
      GET api/v1/show_media_by_code/XYZ100
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
        account = Account.find_by_code(params[:id])
        medias = account.medias.all
        render json: { status: 'SUCCESS', message: 'Loaded media', data: medias
}, status: :ok
      end

      private

      def params_account
        params.permit(:code, :name, :password)
      end
    end
  end
end
