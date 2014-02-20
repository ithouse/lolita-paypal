module LolitaPaypal
  module Billing
    def self.included(base)
      base.has_many :paypal_transactions, as: :paymentable, class_name: 'LolitaPaypal::Transaction', dependent: :destroy
      base.class_eval do

        # Payment description
        def description
          raise 'Redefine this method in your billing model.'
        end

        # Price of payment in cents
        def price
          raise 'Redefine this method in your billing model.'
        end

        # Currency as 3 letter code as in ISO 4217
        def currency
          raise 'Redefine this method in your billing model.'
        end

        def paypal_trx_saved trx
          raise 'Redefine this method in your billing model.'
        end

        # Paypal will redirect to this path after payment
        def paypal_return_path
          raise 'Redefine this method in your billing model.'
        end

        # To pass any extra parameter to paypal, redefine 'paypal_request_variables'
        # with any of these keys. Keys business, item_name, amount, currency_code - already are added.
        #+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        #| business      | Email address on your PayPal account                                                                                                                                                              |
        #| quantity      | Number of items. This will multiply the amount if greater than one                                                                                                                                |
        #| item_name     | Name of the item (or a name for the shopping cart). Must be alpha-numeric, with a 127character limit                                                                                              |
        #| item_number   | Optional pass-through variable for you to track payments. Must be alpha-numeric, with a 127 character limit                                                                                       |
        #| amount        | Price of the item (the total price of all items in the shopping cart)                                                                                                                             |
        #| shipping      | The cost of shipping the item                                                                                                                                                                     |
        #| shipping2     | The cost of shipping each additional item                                                                                                                                                         |
        #| handling      | The cost of handling                                                                                                                                                                              |
        #| tax           | Transaction-based tax value. If present, the value passed here will override any profile tax settings you may have (regardless of the buyer's location).                                          |
        #| no_shipping   | Shipping address. If set to "1," your customer will not be asked for a shipping address. This is optional; if omitted or set to "0," your customer will be prompted to include a shipping address |
        #| cn            | Optional label that will appear above the note field (maximum 40 characters)                                                                                                                      |
        #| no_note       | Including a note with payment. If set to "1," your customer will not be prompted to include a note. This is optional; if omitted or set to "0," your customer will be prompted to include a note. |
        #| on0           | First option field name. 64 character limit                                                                                                                                                       |
        #| os0           | First set of option value(s). 200 character limit. "on0" must be defined for "os0" to be recognized.                                                                                              |
        #| on1           | Second option field name. 64 character limit                                                                                                                                                      |
        #| os1           | Second set of option value(s). 200 character limit. "on1" must be defined for "os1" to be recognized.                                                                                             |
        #| custom        | Optional pass-through variable that will never be presented to your customer. Can be used to track inventory                                                                                      |
        #| invoice       | Optional pass-through variable that will never be presented to your customer. Can be used to track invoice numbers                                                                                |
        #| notify_url    | Only used with IPN. An internet URL where IPN form posts will be sent                                                                                                                             |
        #| return        | An internet URL where your customer will be returned after completing payment                                                                                                                     |
        #| cancel_return | An internet URL where your customer will be returned after cancelling payment                                                                                                                     |
        #| image_url     | The internet URL of the 150 X 50 pixel image you would like to use as your logo                                                                                                                   |
        #| cs            | Sets the background color of your payment pages. If set to "1," the background color will be black. This is optional; if omitted or set to "0," the background color will be white                |
        #+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        # more info at https://www.paypal.com/cgi-bin/webscr?cmd=p/pdn/howto_checkout-outside
        def paypal_request_variables
          {}
        end

        # Add this to your paid? method along with other payment methods
        # Example:
        #     def paid?
        #       paypal_paid? || first_data_paid?
        #     end
        def paypal_paid?
          self.paypal_transactions.where(status: 'Completed').count >= 1
        end
      end
    end
  end
end
