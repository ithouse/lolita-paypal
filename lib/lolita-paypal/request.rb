module LolitaPaypal

  class Request
    attr_reader :payment

    def initialize(payment = nil)
      @payment = payment
    end

    def self.encrypt_for_paypal(values)
      signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(LolitaPaypal.app_cert_pem), OpenSSL::PKey::RSA.new(LolitaPaypal.app_key_pem, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
      OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(LolitaPaypal.paypal_cert_pem)], signed.to_der, OpenSSL::Cipher::Cipher::new('DES3'), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
    end

    def amount(money)
      cents = money.respond_to?(:cents) ? money.cents : money
      if money.nil? || cents.to_i <= 0
        raise ArgumentError, 'money amount must be either a Money object or a positive integer in cents.'
      end
      sprintf("%.2f", cents.to_f / 100)
    end

    def payment_id
      payment.id
    end

    def request_variables
      {
        'cert_id' => LolitaPaypal.cert_id,
        'cmd' => '_xclick',
        'business' =>  LolitaPaypal.account_name,
        'item_name' => payment.description,
        'custom' =>"#{payment.class.to_s.underscore}___#{payment_id}",
        'amount' => amount(payment.price),
        'currency_code' => payment.currency,
        'no_note' => '1',
        'no_shipping' => '1',
        'return' => payment.paypal_return_path
      }.merge(payment.paypal_request_variables)
    end
  end
end
