# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::MediasController, type: :controller do
  before(:each) do
    @account = FactoryBot.create(:account)
    #FactoryBot.create_list(:media, 10, account_id: @account.id)
    for i in 60..65 do
      FactoryBot.create(:media, account_id: @account.id, title: i.to_s +
'xYz', asset_id: i.to_s + 'abc', duration: i)
    end
    for i in 60..65 do
      FactoryBot.create(:media, account_id: @account.id, title: i.to_s +
'Abc', asset_id: i.to_s + 'xyz', duration: i)
    end 
  end

  context 'GET #index' do
    it 'should return a success response' do
     get :index, params: { asset_id: 'Bc', title: 'title', duration: 10 }
     expect(response).to be_success
    end

    it 'should return a successful json string with message' do
      get :index, params: { asset_id: 'ABc', title: 'yz' }
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['message']).to eq('Loaded medias')
    end

    it 'should search by asset_id if only asset_id param is given' do
      get :index, params: { asset_id: 'AB' }
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].map{ |item| item['asset_id']}).to eq(["60abc", "61abc", "62abc", "63abc", "64abc", "65abc"])
    end

    it 'should search by title if only title param is given' do
      get :index, params: { title: '0' }
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].map{ |item| item['title']}).to eq(["60xYz", "60Abc"])
    end

    it 'should search by duration based on from and to if only from and to
params are given' do
      get :index, params: { from: 62, to: 65 }
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].map{ |item| item['asset_id']}).to eq(["62abc", "62xyz", "63abc", "63xyz", "64abc", "64xyz", "65abc", "65xyz"])
    end

    it 'should search by asset_id, title and duration if all the three params
are given' do
      get :index, params: { asset_id: '1A', title: 'yz', duration: 62 }
      expect(response).to be_success
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["data"].map{ |item| item["asset_id"]}).to eq(["61abc"])
    end
  end
end
