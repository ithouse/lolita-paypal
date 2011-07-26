PAYPAL_CERT_PEM = RAILS_ROOT + "/config/paypal/#{RAILS_ENV}/paypal_cert.pem"
PAYPAL_APP_CERT_PEM = RAILS_ROOT + "/config/paypal/#{RAILS_ENV}/my-pubcert.pem"
PAYPAL_APP_KEY_PEM = RAILS_ROOT + "/config/paypal/#{RAILS_ENV}/my-prvkey.pem"

module Lolita
  module Paypal
    mattr_accessor :paypal_cert_pem, :app_cert_pem, :app_key_pem, :url, :cert_id, :account

    # defaults
    self.paypal_cert_pem = PAYPAL_CERT_PEM
    self.app_cert_pem = PAYPAL_APP_CERT_PEM
    self.app_key_pem = PAYPAL_APP_CERT_PEM

  end
end
