module LolitaPaypal
  module ApplicationHelper
    include Rails.application.routes.url_helpers

    # returns encrypted request variables
    def encrypt_request(payment_request)
      variables = payment_request.request_variables.reverse_merge({
        'notify_url'=> answer_paypal_url(protocol: 'https')
      })
      LolitaPaypal::Request.encrypt_for_paypal variables
    ensure
      LolitaPaypal.logger.info "[#{payment_request.payment_id}] #{variables}"
    end
  end
end
