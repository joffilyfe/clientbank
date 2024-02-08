# frozen_string_literal: true

module Units
  module CreateTransfer
    class Action

      def initialize(inputs)
        @inputs = inputs
      end

      def call
        raise Units::ValidationError.new(inputs.errors) if inputs.failure? # rubocop:disable Style/RaiseArgs

        ActiveRecord::Base.transaction do
          bank_account.update(balance: bank_account.balance - debit)
          create_transfers
        end
      end

      private

      attr_reader :inputs

      def bank_account
        @bank_account ||= BankAccount.find_by(organization_name: inputs[:organization_name])
      end

      def transfers
        @transfers ||= inputs[:credit_transfers]
      end

      def debit
        transfers.sum { |transfer| transfer[:amount] }.to_money
      end

      def create_transfers
        transfers.map do |transfer|
          Transfer.create(bank_account:, **transfer)
        end
      end

    end
  end
end
