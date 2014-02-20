class Reservation < ActiveRecord::Base
  include LolitaPaypal::Billing

  def paid?
    paypal_paid?
  end

  # Methods for LolitaPaypal
  #-----------------------
  def price
    full_price
  end

  # string up to 125 symbols
  def description
    "testing"
  end

  def currency
    "EUR"
  end

  def paypal_trx_saved trx
    case trx.status
    when 'Canceled-Reversal' then update_attribute(:status, 'failed')
    when 'Completed' then update_attribute(:status, 'completed')
    when 'Denied' then update_attribute(:status, 'failed')
    when 'Expired' then update_attribute(:status, 'failed')
    when 'Failed' then update_attribute(:status, 'failed')
    when 'In-Progress' then update_attribute(:status, 'processing')
    when 'Partially-Refunded' then update_attribute(:status, 'failed')
    when 'Pending' then update_attribute(:status, 'processing')
    when 'Processed' then update_attribute(:status, 'processing')
    when 'Refunded' then update_attribute(:status, 'failed')
    when 'Reversed' then update_attribute(:status, 'reversed')
    when 'Voided' then update_attribute(:status, 'failed')
    else update_attribute(:status, 'failed')
    end
  end

  def paypal_return_path
    "/reservation/done"
  end
  #-----------------------
end
