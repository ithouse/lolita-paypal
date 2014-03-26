Rails.application.routes.draw do
  get "/paypal/checkout" => "lolita_paypal/transactions#checkout", as: "checkout_paypal"
  get "/paypal/answer" => "lolita_paypal/transactions#answer", as: "answer_paypal"
  post "/paypal/answer" => "lolita_paypal/transactions#answer"
end
