ENV['RAILS_ENV'] = 'test'
ENV['PAYPAL_CERT_ID'] = '123'
ENV['PAYPAL_ACCOUNT_NAME'] = 'Shop'
ENV['PAYPAL_CERT_PEM'] = File.dirname(__FILE__)+'/fixtures/paypal_cert.pem'
ENV['PAYPAL_APP_CERT_PEM'] = File.dirname(__FILE__)+'/fixtures/app_cert.pem'
ENV['PAYPAL_APP_KEY_PEM'] = File.dirname(__FILE__)+'/fixtures/app_key.pem'

require 'rubygems' 
require 'bundler/setup'
require 'simplecov'
SimpleCov.start 'rails'

require 'pry-byebug'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'
require 'database_cleaner'

Rails.backtrace_cleaner.remove_silencers!

require 'fabrication'
Fabrication::Config.path_prefix = File.dirname(File.expand_path('../', __FILE__))

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Rails.application.routes.default_url_options[:host] = 'test.host'

RSpec.configure do |config|
  config.mock_with :rspec
  DatabaseCleaner.strategy = :truncation
  config.before(:each) do
    DatabaseCleaner.clean
  end
end
