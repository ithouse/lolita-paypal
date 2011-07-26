module Lolita::Paypal
  class TransactionController < Lolita::Paypal::CommonController
    before_filter :is_ssl_required
    protect_from_forgery :except => :answer
    include ActiveMerchant::Billing::Integrations

    def checkout
      @payment_request = Lolita::Paypal::Request.new(@payment)
      render "lolita/paypal/payment_form", :layout => false
    end

    #ipn
    def answer
      # Create a notify object we must
      notify = Paypal::Notification.new(request.raw_post)
      #RAILS_DEFAULT_LOGGER.info "notify=#{notify.to_yaml}"
      parts = notify.params["custom"].split("___")
      #we must make sure this transaction id is not allready completed
      payment = parts[0].constantize.find_by_id(parts[1]) rescue nil
      trans = Lolita::Paypal::Transaction.completed_transactions(notify.transaction_id, payment)
      if payment && trans.empty?
        if notify.acknowledge
          begin
            trans=Lolita::Paypal::Transaction.update_with_request(notify, payment, request)
            if notify.complete?
              #redirect_to "#{session[:payment_data][:finish_path]}?merchant=paypal&trx_id=#{rs.get_trx_id}"
            end
          rescue => e
            # no where to rescue. client newer see this
            rescue_action_in_public(e)
            return
          ensure
            #make sure we logged everything we must
          end
        else
          # transaction was not acknowledged (fraud and so on)
          # this route is available public
        end
      end

      render :nothing => true
    end

    private

    # forces SSL in production mode if available
    def is_ssl_required
      ssl_required(:answer, :checkout) if defined?(ssl_required) && (RAILS_ENV == 'production' || RAILS_ENV == 'staging')
    end
  end
end
