require 'digest/md5'
require 'openssl'
require 'activemerchant'
require 'lolita-paypal/custom_logger'
require 'lolita-paypal/request'
require 'lolita-paypal/engine'
require 'lolita-paypal/version'
require 'lolita-paypal/billing'

module LolitaPaypal
  mattr_accessor :custom_logger

  def self.cert_id
    @cert_id ||= ENV['PAYPAL_CERT_ID']
  end

  def self.account_name
    @account_name ||= ENV['PAYPAL_ACCOUNT_NAME']
  end

  def self.paypal_cert_pem
    @paypal_cert_pem ||= File.read ENV['PAYPAL_CERT_PEM']
  end

  def self.app_cert_pem
    @app_cert_pem ||= File.read ENV['PAYPAL_APP_CERT_PEM']
  end

  def self.app_key_pem
    @app_key_pem ||= File.read ENV['PAYPAL_APP_KEY_PEM']
  end

  def self.logger
    unless @logger
      @logger = custom_logger ? custom_logger : default_logger
    end
    @logger
  end

  protected

  def self.default_logger
    logger = Logger.new(Rails.root.join('log', 'lolita_paypal.log'))
    logger.formatter = LolitaPaypal::LogFormatter.new
    logger
  end
end
