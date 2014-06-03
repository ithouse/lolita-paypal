require "ipaddr"
# Available statuses
# -----------------
# Canceled-Reversal
# Completed
# Denied
# Expired
# Failed
# In-Progress
# Partially-Refunded
# Pending
# Processed
# Refunded
# Reversed
# Voided
module LolitaPaypal
  class Transaction < ActiveRecord::Base
    self.table_name = "paypal_transactions"
    belongs_to :paymentable, polymorphic: true
    after_save :touch_paymentable
    default_scope -> { order(:id) }
    validates_associated :paymentable

    def ip
      IPAddr.new(self[:ip].to_i, Socket::AF_INET).to_s
    end

    def ip=(x)
      self[:ip] = IPAddr.new(x).to_i
    end

    # add new transaction after IPN response
    def self.create_transaction notify, payment, request
      self.create!(
        transaction_id: notify.transaction_id,
        status: notify.status,
        paymentable: payment,
        ip: request.remote_ip
      )
    end

    private

    # trigger "paypal_trx_saved" on our paymentable model
    def touch_paymentable
      paymentable.paypal_trx_saved(self)
    end
  end
end
