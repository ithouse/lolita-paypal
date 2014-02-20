require "spec_helper"

describe LolitaPaypal::ApplicationHelper do
  describe "#encrypt_request" do
    let(:payment_request){ double(request_variables: {a: 1}, payment_id: 1) }

    it "should return string with some ecrypted data" do
      expect(encrypt_request(payment_request)).to be_a(String)
    end
  end
end

