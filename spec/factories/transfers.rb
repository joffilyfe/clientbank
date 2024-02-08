# frozen_string_literal: true

FactoryBot.define do
  factory :transfer do
    counterparty_name { 'megacorp' }
    counterparty_iban { 'iban' }
    counterparty_bic { 'bic' }
    amount { 10.to_money }
    bank_account
  end
end
