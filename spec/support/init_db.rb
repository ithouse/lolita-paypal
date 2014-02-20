# Add models
ActiveRecord::Schema.define do
  create_table :paypal_transactions do |t|
    t.string   :transaction_id
    t.string   :status
    t.references :paymentable, polymorphic: true
    t.string   :ip
    t.timestamps
  end

  create_table :reservations do |t|
    t.integer :full_price
    t.string :status

    t.timestamps
  end
end
