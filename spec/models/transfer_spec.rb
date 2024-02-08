# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfer do
  subject { transfer }

  let(:transfer) { build(:transfer) }

  it { is_expected.to belong_to(:bank_account) }

  it { expect(subject.amount.class).to eq(Money) }
end
