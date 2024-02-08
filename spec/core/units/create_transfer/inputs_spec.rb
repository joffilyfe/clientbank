# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Units::CreateTransfer::Inputs do
  subject { described_class.new.call(payload) }

  let(:bank_account) { create(:bank_account, balance: 100.to_money) }
  let(:organization_name) { bank_account.organization_name }
  let(:create_transfers) do
    [
      { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: '10', description: '1' },
      { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: '5.02', description: '2' },
      { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: 5.03, description: '3' }
    ]
  end
  let(:payload) do
    {
      organization_name:,
      organization_bic: 'bic',
      organization_iban: 'iban',
      credit_transfers: create_transfers
    }
  end

  it { expect(subject.failure?).to be(false) }

  context 'when payload is invalid' do
    describe '#organization_name' do
      let(:organization_name) { 'do_not_exist' }

      it { expect(subject.errors[:organization_name]).to eq(['Bank Account does not exist']) }
    end

    describe '#credit_transfers' do
      let(:create_transfers) { [] }

      it { expect(subject.errors[:credit_transfers]).to eq(['must be filled']) }

      context 'when amount is zero' do # rubocop:disable RSpec/NestedGroups
        let(:create_transfers) do
          [
            { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: '0', description: '1' }
          ]
        end

        it { expect(subject.errors[:credit_transfers]).to eq({ 0 => { amount: ['must be greater than 0'] } }) }
      end

      context 'when amount less than zero' do # rubocop:disable RSpec/NestedGroups
        let(:create_transfers) do
          [
            { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: -10, description: '1' }
          ]
        end

        it { expect(subject.errors[:credit_transfers]).to eq({ 0 => { amount: ['must be greater than 0'] } }) }
      end

      context 'when amount is greater than bank account balance' do # rubocop:disable RSpec/NestedGroups
        let(:amount) { 1001 }
        let(:create_transfers) do
          [
            { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount:, description: '1' }
          ]
        end

        it { expect(subject.errors[:credit_transfers]).to eq(['Not enough money']) }
      end
    end
  end
end
