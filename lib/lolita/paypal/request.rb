module Lolita::Paypal
  class Request
    @@paypal_cert_pem = File.read(Lolita::Paypal.paypal_cert_pem)
    @@app_cert_pem = File.read(Lolita::Paypal.app_cert_pem)
    @@app_key_pem = File.read(Lolita::Paypal.app_key_pem)
    
    def initialize(payment=nil)
      @payment = payment
    end

    def self.encrypt_for_paypal(values)
      signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(@@app_cert_pem), OpenSSL::PKey::RSA.new(@@app_key_pem, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
      OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(@@paypal_cert_pem)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
    end

    def payment
      @payment
    end

    def currency value
      value =~ /\d{3}/ ? ISO4217[value] : value
    end

    def amount(money)
      return nil if money.nil?
      cents = money.respond_to?(:cents) ? money.cents : money

      if money.is_a?(String) or cents.to_i < 0
        raise ArgumentError, 'money amount must be either a Money object or a positive integer in cents.'
      end

      sprintf("%.2f", cents.to_f / 100)
    end

    private

    ISO4217 = {
      '971' => 'AFA',
      '533' => 'AWG',
      '036' => 'AUD',
      '032' => 'ARS',
      '944' => 'AZN',
      '044' => 'BSD',
      '050' => 'BDT',
      '052' => 'BBD',
      '974' => 'BYR',
      '068' => 'BOB',
      '986' => 'BRL',
      '826' => 'GBP',
      '975' => 'BGN',
      '116' => 'KHR',
      '124' => 'CAD',
      '136' => 'KYD',
      '152' => 'CLP',
      '156' => 'CNY',
      '170' => 'COP',
      '188' => 'CRC',
      '191' => 'HRK',
      '196' => 'CPY',
      '203' => 'CZK',
      '208' => 'DKK',
      '214' => 'DOP',
      '951' => 'XCD',
      '818' => 'EGP',
      '232' => 'ERN',
      '233' => 'EEK',
      '978' => 'EUR',
      '981' => 'GEL',
      '288' => 'GHC',
      '292' => 'GIP',
      '320' => 'GTQ',
      '340' => 'HNL',
      '344' => 'HKD',
      '348' => 'HUF',
      '352' => 'ISK',
      '356' => 'INR',
      '360' => 'IDR',
      '376' => 'ILS',
      '388' => 'JMD',
      '392' => 'JPY',
      '368' => 'KZT',
      '404' => 'KES',
      '414' => 'KWD',
      '428' => 'LVL',
      '422' => 'LBP',
      '440' => 'LTL',
      '446' => 'MOP',
      '807' => 'MKD',
      '969' => 'MGA',
      '458' => 'MYR',
      '470' => 'MTL',
      '977' => 'BAM',
      '480' => 'MUR',
      '484' => 'MXN',
      '508' => 'MZM',
      '524' => 'NPR',
      '532' => 'ANG',
      '901' => 'TWD',
      '554' => 'NZD',
      '558' => 'NIO',
      '566' => 'NGN',
      '408' => 'KPW',
      '578' => 'NOK',
      '512' => 'OMR',
      '586' => 'PKR',
      '600' => 'PYG',
      '604' => 'PEN',
      '608' => 'PHP',
      '634' => 'QAR',
      '946' => 'RON',
      '643' => 'RUB',
      '682' => 'SAR',
      '891' => 'CSD',
      '690' => 'SCR',
      '702' => 'SGD',
      '703' => 'SKK',
      '705' => 'SIT',
      '710' => 'ZAR',
      '410' => 'KRW',
      '144' => 'LKR',
      '968' => 'SRD',
      '752' => 'SEK',
      '756' => 'CHF',
      '834' => 'TZS',
      '764' => 'THB',
      '780' => 'TTD',
      '949' => 'TRY',
      '784' => 'AED',
      '840' => 'USD',
      '800' => 'UGX',
      '980' => 'UAH',
      '858' => 'UYU',
      '860' => 'UZS',
      '862' => 'VEB',
      '704' => 'VND',
      '894' => 'AMK',
      '716' => 'ZWD'
    }
  end
end
