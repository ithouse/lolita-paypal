require 'spec_helper'

describe LolitaPaypal::Request do
  let(:payment){
    double(id: 1,
           price: 200,
           currency: 'EUR',
           description: 'Some text',
           paypal_return_path: '/reservation/done',
           paypal_request_variables: {})
  }

  subject{ described_class.new payment }

  describe '.encrypt_for_paypal' do
    it 'returns some encrypted string' do
      expect(described_class.encrypt_for_paypal({a: 1})).to be_a(String)
    end
  end

  describe '#amount' do
    context 'as money object' do
      it 'returns full decimal price' do
        expect(subject.amount(double(cents: 1000))).to eq('10.00')
      end
    end

    context 'as cents' do
      it 'returns full decimal price' do
        expect(subject.amount(1000)).to eq('10.00')
      end
    end
  end

  describe '#payment_id' do
    it 'returns payment id' do
      expect(subject.payment_id).to eq(1)
    end
  end

  describe '#request_variables' do
    let(:variables){ subject.request_variables }

    context 'without extra variables' do
      it 'should return required variables' do
        expect(variables['cert_id']).to eq('123')
        expect(variables['cmd']).to eq('_xclick')
        expect(variables['business']).to eq('Shop')
        expect(variables['item_name']).to eq('Some text')
        expect(variables['custom']).to eq('RSpec::Mocks::Mock___1')
        expect(variables['amount']).to eq('2.00')
        expect(variables['currency_code']).to eq('EUR')
        expect(variables['no_note']).to eq('1')
        expect(variables['no_shipping']).to eq('1')
        expect(variables['return']).to eq('/reservation/done')
      end
    end

    context 'with extra variables' do
      let(:payment){ super().stub(paypal_request_variables: {'no_note' => '2'}) ; super() }

      it 'should merge in variables from paymentable' do
        expect(variables['no_note']).to eq('2')
      end
    end
  end
end
