# frozen_string_literal: true

module Units
  module CreateTransfer
    class Inputs < Dry::Validation::Contract

      json do
        required(:organization_name).filled(:string)
        required(:organization_bic).filled(:string)
        required(:organization_iban).filled(:string)
        required(:credit_transfers).filled.array(:hash) do
          required(:amount).filled(:decimal, gt?: 0)
          required(:counterparty_name).filled(:string)
          required(:counterparty_bic).filled(:string)
          required(:counterparty_iban).filled(:string)
          required(:description).filled(:string)
        end
      end

      rule(:organization_name) do
        key.failure('Bank Account does not exist') unless bank_account(values)
      end

      rule(:credit_transfers) do
        amount = values[:credit_transfers].sum { |transfer| transfer[:amount] }.to_money
        account = bank_account(values)

        key.failure('Not enough money') if account && account.balance.to_money < amount
      end

      private

      def bank_account(values)
        bic = values[:organization_bic]
        iban = values[:organization_iban]

        BankAccount.where(bic:, iban:).first
      end

    end
  end
end
