# frozen_string_literal: true
Apipie.configure do |config|
  config.app_name                = 'MetaStoreApp'
  config.api_base_url            = '/api/v1'
  config.doc_base_url            = '/apipie'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.translate = false
end
