# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankAccount do
  subject { bank_account }

  let(:bank_account) { build(:bank_account) }

  it { expect(subject.balance.class).to eq(Money) }

  context 'when there is balance' do
    let(:bank_account) { build(:bank_account, :without_balance) }

    it { expect(subject.balance).to eq(0.to_money) }
  end
end
