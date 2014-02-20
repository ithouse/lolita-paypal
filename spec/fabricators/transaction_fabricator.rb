Fabricator(:transaction, class_name: 'LolitaPaypal::Transaction') do
  status 'processing'
  paymentable fabricator: :reservation
  ip '100.100.100.100'
end
