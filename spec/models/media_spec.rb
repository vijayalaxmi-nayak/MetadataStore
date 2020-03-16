# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Media, type: :model do
  before(:each) do
    @account = FactoryBot.create(:account)
    for i in 60..65 do
      FactoryBot.create(:media, account_id: @account.id, title: i.to_s +
'xYz', asset_id: i.to_s + 'abc', duration: i)
    end
    for i in 60..65 do
      FactoryBot.create(:media, account_id: @account.id, title: i.to_s +
'Abc', asset_id: i.to_s + 'xyz', duration: i)
    end
  end

  context 'validation test' do
    it 'should create a media record on validation success' do
      metadata = FactoryBot.build(:media, account_id: @account.id)
      status = metadata.save
      expect(status).to eq(true)
    end
  end

  context 'Check the funcationality of searches and filters' do
    it 'should search by asset_id if only asset_id param is passed' do
      metadata = Media.search_by_asset_id('2')
      expect(metadata.pluck(:asset_id)).to eq(['62abc','62xyz'])
    end

    it 'should search by title if only title param is passed' do
      metadata = Media.search_by_title('1XYZ')
      expect(metadata.pluck(:title)).to eq(["61xYz"])
    end

    it 'should search by asset_id, title, and duration if all three params are
provided' do
      metadata = Media.search_by_asset_id('AbC')
      metadata = metadata.search_by_title('xy')
      metadata = metadata.search_by_duration(62)
      expect(metadata.pluck(:asset_id)).to eq(["60abc", "61abc", "62abc"])
    end
  end
end
