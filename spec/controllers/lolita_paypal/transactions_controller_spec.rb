require 'spec_helper'
describe LolitaPaypal::TransactionsController do
  render_views
  let(:reservation){ Fabricate(:reservation) }

  describe "#checkout" do
    context "with paid payment" do
      before do
        session[:payment_data] = {
          billing_class: "Reservation",
          billing_id: reservation.id
        }
        Reservation.any_instance.stub(paid?: true)
      end

      it "should return error" do
        get :checkout
        expect(response.status).to eq(400)
      end
    end

    context "with unpaid payment" do
      before do
        session[:payment_data] = {
          billing_class: "Reservation",
          billing_id: reservation.id
        }
      end

      it "should render form" do
        get :checkout
        expect(response).to render_template("lolita_paypal/payment_form")
      end
    end
  end

  describe "#answer" do

    it "should fail with wrong request" do
      get :answer
      expect(response.body).to eq("Wrong request")
    end

    it "should successfuly handle transaction" do
      ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stub(:acknowledge).and_return(true)
      post :answer , {
            "mc_gross"=>"10.00",
            "invoice"=>"123",
            "protection_eligibility"=>"Eligible",
            "address_status"=>"confirmed",
            "payer_id"=>"12345678",
            "tax"=>"0.00",
            "address_street"=>"any address",
            "payment_date"=>Time.now,
            "payment_status"=>"Completed",
            "type"=> "Completed",
            "charset"=>"windows-1252",
            "address_zip"=>"94304",   
            "first_name"=>"first",   
            "mc_fee"=>"0.50",   
            "address_country_code"=>"US",   
            "address_name"=>"address name",   
            "notify_version"=>"3.7",   
            "custom"=>"#{reservation.class}___#{reservation.id}",
            "payer_status"=>"unverified",
            "business"=>"sales@example.com",
            "address_country"=>"United States",
            "address_city"=>"anything",
            "quantity"=>"1",
            "verify_sign"=>"AXRgIKi50FXdGRGh8D815JH-YEftIeF9KOlO6Gi33F4OFxtUxjfFhG58",
            "payer_email"=>"me@you.com",
            "txn_id"=>"123123",
            "payment_type"=>"instant",
            "last_name"=>"last",
            "address_state"=>"CA",
            "receiver_email"=>"sales@example.com",
            "payment_fee"=>"0.50",
            "receiver_id"=>"Q2SKLFWSCF2JY",
            "txn_type"=>"web_accept",
            "item_name"=>"",
            "mc_currency"=>"EUR",
            "item_number"=>"",
            "residence_country"=>"US",
            "handling_amount"=>"0.00",
            "transaction_subject"=>"some thing",
            "payment_gross"=>"7.00",
            "shipping"=>"0.00",
            "ipn_track_id"=>"4a4r5u8tr32d8"}
      expect(reservation.paypal_transactions.first.status).to eq("Completed")
      expect(reservation.paid?).to be_true
      expect(response.status).to eq(200)
    end
  end
end
