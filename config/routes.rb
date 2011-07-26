ActionController::Routing::Routes.draw do |map|
  map.checkout_paypal '/paypal/checkout', :controller => 'Lolita::Paypal::Transaction', :action => 'checkout'
  map.answer_paypal   '/paypal/answer'  , :controller => 'Lolita::Paypal::Transaction', :action => 'answer'
  # Public routes using https protocol
  #map.with_options :protocol => 'https' do |https|
  #  https.answer_paypal   '/paypal/answer'  , :controller => 'Lolita::Paypal::Transaction', :action => 'answer'
  #end
  #map.connect '/paypal_test/:action', :controller => 'Lolita::Paypal::Test'
end

