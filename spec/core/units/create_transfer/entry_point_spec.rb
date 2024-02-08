# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Units::CreateTransfer::EntryPoint do
  subject { described_class.call(payload) }

  let(:bank_account) { create(:bank_account, balance: 100.to_money) }
  let(:organization_name) { bank_account.organization_name }
  let(:bic) { bank_account.bic }
  let(:iban) { bank_account.iban }
  let(:payload) do
    {
      organization_name:,
      organization_bic: bic,
      organization_iban: iban,
      credit_transfers: [
        { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: '10', description: '1' },
        { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: '5.02', description: '2' },
        { counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: 5.03, description: '3' }
      ]
    }
  end

  before { bank_account }

  it { expect { subject }.to change(Transfer, :count).by(3) }
  it { expect { subject && bank_account.reload }.to change(bank_account, :balance).to(79.95.to_money) }

  context 'when bank_account balance is insufficient to perfom all transfers' do
    let(:bank_account) { create(:bank_account, :without_balance) }

    it { expect { subject }.to raise_error(Units::ValidationError).with_message(/Not enough money/) }
    it { expect { subject }.to raise_error(Units::ValidationError).and not_change(Transfer, :count) }
  end

  context 'when bank account does not exist' do
    let(:bic) { 'does_not_exist' }

    it { expect { subject }.to raise_error(Units::ValidationError).with_message(/Bank Account does not exist/) }
    it { expect { subject }.to raise_error(Units::ValidationError).and not_change(Transfer, :count) }
  end

  context 'when payload validation fails' do
    let(:organization_name) { nil }

    it { expect { subject }.to raise_error(Units::ValidationError).and not_change(Transfer, :count) }

    it do
      expect do
        subject && bank_account.reload
      end.to raise_error(Units::ValidationError).and not_change(bank_account, :balance)
    end
  end
end
