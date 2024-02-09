# frozen_string_literal: true

FactoryBot.define do
  factory :bank_account do
    organization_name { 'megacorp' }
    iban { 'iban' }
    bic { 'bic' }
    balance { 1000.to_money }

    trait :without_balance do
      balance { 0.to_money }
    end
  end
end
