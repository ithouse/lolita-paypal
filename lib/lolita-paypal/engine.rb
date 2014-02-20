module LolitaPaypal
  class Engine < ::Rails::Engine
    isolate_namespace LolitaPaypal

    config.after_initialize do
      ActiveMerchant::Billing::PaypalGateway.pem_file = LolitaPaypal.paypal_cert_pem
    end
  end
end
