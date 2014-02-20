require "spec_helper"

describe LolitaPaypal do
  it "should have default attributes" do
    LolitaPaypal.paypal_cert_pem.should_not be_nil
    LolitaPaypal.app_cert_pem.should_not be_nil
    LolitaPaypal.app_key_pem.should_not be_nil
  end
end
