# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Video, type: :model do
  context 'timecode test for video' do
    it 'should update timecode based on the value of duration passed' do
      @account = FactoryBot.create(:account)
      @metadata = FactoryBot.build(:media, account_id: @account.id, duration:
12000, media_type: 'video')
      # byebug
      expect(Video.duration_tc(@metadata.duration)).to eq('00:00:12:00')
    end
  end
end
