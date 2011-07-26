module PaypalHelper

    def encrypted_basic(payment_request)
    
      # cert_id is the certificate if we see in paypal when we upload our own certificates
      # cmd _xclick need for buttons
      # item name is what the user will see at the paypal page
      # custom and invoice are passthrough vars which we will get back with the asunchronous
      # notification
      # no_note and no_shipping means the client want see these extra fields on the paypal payment
      # page
      # return is the url the user will be redirected to by paypal when the transaction is completed.
      decrypted = {
        "cert_id" => Lolita::Paypal.cert_id,
        "cmd" => "_xclick",
        "business" =>  Lolita::Paypal.account,
        "item_name" => payment_request.payment.description,
        "item_number" => payment_request.payment.number,
        "custom" =>"#{payment_request.payment.class.to_s}___#{payment_request.payment.id.to_s}", #identify payment
        "amount" => payment_request.amount(payment_request.payment.price),
        "currency_code" => payment_request.currency(payment_request.payment.currency),
        "country" => "US",
        "no_note" => "1",
        "no_shipping" => "1",
        #"notify_url"=> answer_paypal_url
        "notify_url"=> answer_paypal_url(:protocol => "https")
      }
      root_url = (RAILS_ENV == 'production' || RAILS_ENV == 'staging') ? "https://"+Lolita.config.system(:domain) : "#{request.protocol}#{request.host_with_port}"
      url = root_url + "#{session[:payment_data][:finish_path]}"
      decrypted.merge!("return"=>url)
 
      RAILS_DEFAULT_LOGGER.info "decrypted=#{decrypted.to_yaml}"
      Lolita::Paypal::Request.encrypt_for_paypal(decrypted)
    end
end
