module Lolita
  module Paypal
    module Billing
      def self.included(base)
        base.has_many :paypal_transactions, :as => :paymentable, :class_name => "Lolita::Paypal::Transaction", :dependent => :destroy
        base.extend ClassMethods
        base.class_eval do
          # returns true if exists transaction with status 'completed'
          # and updates status if needed
          def paid_with_paypal?
            return true if self.paypal_transactions.count(:conditions => {:status => 'Completed'}) >= 1
            paid_without_paypal?
          end
          alias_method_chain :paid?, :paypal
        end
      end

      module ClassMethods
        def log severity, message
          raise "Redefine this method in your billing model."
        end

        def paypal_trx_saved trx
          raise "Redefine this method in your billing model."
        end  
      end
    end
  end
end
