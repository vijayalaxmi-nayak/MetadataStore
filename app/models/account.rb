# frozen_string_literal: true
class Account < ApplicationRecord
  has_many :medias, dependent: :destroy
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true
end
