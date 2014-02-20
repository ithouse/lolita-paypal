require "spec_helper"

describe LolitaPaypal::Billing do
  let(:transaction){ Fabricate(:transaction) }
  subject(:reservation){ transaction.paymentable }

  describe '#paypal_paid?' do
    context 'with completed transaction' do
      let(:transaction){ Fabricate(:transaction, status: 'Completed') }
      it 'be true' do
        expect(reservation.paypal_paid?).to be_true
      end
    end

    context 'with failed transaction' do
      let(:transaction){ Fabricate(:transaction, status: 'Failed') }
      it 'be false' do
        expect(reservation.paypal_paid?).to be_false
      end
    end
  end
end
