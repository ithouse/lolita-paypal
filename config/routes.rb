Rails.application.routes.draw do
  get "/checkout" => "lolita_paypal/transactions#checkout", as: "checkout_paypal"
  post "/answer" => "lolita_paypal/transactions#answer", as: "answer_paypal"
end
