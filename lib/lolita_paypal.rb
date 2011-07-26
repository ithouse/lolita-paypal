require 'ipaddr'
require 'active_support'
require 'action_view'
require 'digest'
require 'md5'
require 'openssl'
require "lolita/paypal/paypal"
require "lolita/paypal/version"
require "lolita/paypal/billing"

require File.join(File.dirname(__FILE__), '../', 'app', 'helpers', 'paypal_helper')
ActionView::Base.send :include, PaypalHelper

