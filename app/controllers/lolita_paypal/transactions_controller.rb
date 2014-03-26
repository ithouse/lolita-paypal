module LolitaPaypal
  class TransactionsController < LolitaPaypal::ApplicationController
    protect_from_forgery except: :answer
    before_filter :is_ssl_required
    before_filter :set_active_payment, :check_valid_payment, only: :checkout

    include ActiveMerchant::Billing::Integrations

    # renders form with encrypted data and redirects to Paypal web interface
    def checkout
      @payment_request = LolitaPaypal::Request.new(@payment)
      render 'lolita_paypal/payment_form'
    ensure
      LolitaPaypal.logger.info("[#{session_id}][#{@payment.id}][checkout]")
    end

    # process ipn request
    # POST is sent from paypal and will create transaction
    # GET is a redirect from paypal and will redirect back to return_path
    def answer
      if request.post?
        if ipn_notify.acknowledge
          LolitaPaypal::Transaction.create_transaction(ipn_notify, payment_from_ipn, request)
        end
        render nothing: true
      else
        if payment_from_ipn
          redirect_to payment_from_ipn.paypal_return_path
        else
          render text: I18n.t('lolita_paypal.wrong_request'), status: 400
        end
      end
    ensure
      LolitaPaypal.logger.info("[#{session_id}][#{payment_from_ipn && payment_from_ipn.id}][answer] #{params}")
    end

    private

    def ipn_notify
      @ipn_notify ||= Paypal::Notification.new(request.raw_post)
    end

    def payment_from_ipn
      if subject = params['custom'] || params['cm']
        klass, id = subject.split('___')
        payment = klass.constantize.find(id)
      end
    end

    # returns current payment instance from session
    def set_active_payment
      @payment ||= session[:payment_data][:billing_class].constantize.find(session[:payment_data][:billing_id])
    rescue
      render text: I18n.t('lolita_paypal.wrong_request'), status: 400
    end

    # payment should not be paid
    def check_valid_payment
      if @payment.paid?
        render text: I18n.t('lolita_paypal.wrong_request'), status: 400
      end
    end

    # forces SSL in production mode if availab:le
    def is_ssl_required
      ssl_required(:answer, :checkout) if defined?(ssl_required)
    end


    def session_id
      request.session_options[:id]
    end
  end
end
