# LolitaPaypal

Paypal plugin for Lolita

## Usage

Add to your Gemfile `gem "lolita-paypal"`

Then run generator `rails g lolita_paypal`

To setup your paymentable object see `spec/dummy/app/models/reservation.rb`

## ENV variables

    PAYPAL_CERT_PEM: ~/production/shared/config/paypal_cert.pem"
    PAYPAL_APP_CERT_PEM: ~/production/shared/config/my-pubcert.pem"
    PAYPAL_APP_KEY_PEM: ~/production/shared/config/my-key.pem
