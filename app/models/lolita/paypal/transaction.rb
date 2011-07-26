module Lolita::Paypal
  class Transaction < ActiveRecord::Base
    set_table_name :paypal_transactions
    belongs_to :paymentable, :polymorphic => true
    after_save :touch_paymentable
    
    def ip
      IPAddr.new(self[:ip], Socket::AF_INET).to_s
    end

    def ip=(x)
      self[:ip] = IPAddr.new(x).to_i
    end

    def self.completed_transactions(transaction_id,payment)
      if payment
        trans=self.find(:all,:conditions=>["transaction_id=? AND status=?",transaction_id,"Completed"])
        trans
      else
        []
      end
    end

    def self.update_with_request(notify, payment, request)
      self.create!(
        :transaction_id=>notify.transaction_id,
        :status=>notify.status,
        :paymentable => payment,
        :ip=>request.remote_ip
      )
    end
    
    private
    
    # trigger "fd_trx_saved" on our paymentable model
    def touch_paymentable
      paymentable.paypal_trx_saved(self) if paymentable
    end
  end
end
