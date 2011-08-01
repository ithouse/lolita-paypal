# encoding: utf-8
require 'rubygems'
gem 'rails', '~>2.3'
require 'i18n'
require 'active_record'
require 'spec'
require 'faker'

# init paypal
require File.dirname(__FILE__)+'/../init.rb'

ActiveRecord::Base.logger = Logger.new(File.open("#{File.dirname(__FILE__)}/database.log", 'w+'))
ActiveRecord::Base.establish_connection({ :database => ":memory:", :adapter => 'sqlite3', :timeout => 500 })

# setup I18n
I18n.available_locales = [:en,:lv,:ru,:fr]
I18n.default_locale = :en
I18n.locale = :en

# load transaction module
require File.dirname(__FILE__)+'/../app/models/lolita/paypal/transaction.rb'

# Add models
ActiveRecord::Schema.define do
  create_table :paypal_transactions do |t|
    t.string :transaction_id
    t.string :status
    t.references :paymentable, :polymorphic => true
    t.string :ip, :length => 10

    t.timestamps
  end

  create_table :reservations do |t|
    t.integer :full_price
    t.string :status

    t.timestamps
  end
end

class Reservation < ActiveRecord::Base
  def paid?
    false
  end
  include Lolita::Paypal::Billing
  
  # Methods for FirstData
  #-----------------------
  def price
    full_price
  end

  # string up to 125 symbols
  def description
    "testing"
  end

  # returns 3 digit string according to http://en.wikipedia.org/wiki/ISO_4217
  def currency
    "840"
  end

  # this is called when FirstData merchant is taking some actions
  # there you can save the log message other than the default log file
  def log severity, message
  end
  
  def paypal_trx_saved trx
    #return true if status == trx.status
    case trx.status
    when 'Canceled-Reversal' then update_attribute(:status, 'failed')
    when 'Completed' then complete
    when 'Denied' then update_attribute(:status, 'failed')
    when 'Expired' then update_attribute(:status, 'failed')
    when 'Failed' then update_attribute(:status, 'failed')
    when 'In-Progress' then update_attribute(:status, 'payment')
    when 'Partially-Refunded' then update_attribute(:status, 'failed')
    when 'Pending' then update_attribute(:status, 'payment')
    when 'Processed' then update_attribute(:status, 'payment')
    when 'Refunded' then update_attribute(:status, 'failed')
    when 'Reversed' then update_attribute(:status, 'reversed')
    when 'Voided' then update_attribute(:status, 'failed')
    else update_attribute(:status, 'failed')
    end
  end
  #-----------------------
end

Spec::Runner.configure do |config|
  config.before(:each) do
    ActiveRecord::Base.connection.execute "DELETE from paypal_transactions"
    ActiveRecord::Base.connection.execute "DELETE from reservations"
  end
end
