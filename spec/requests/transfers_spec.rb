# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transfers' do
  let(:bank_account) { create(:bank_account, balance: 10.to_money) }
  let(:params) do
    {
      organization_name: bank_account.organization_name,
      organization_bic: 'bic',
      organization_iban: 'iban',
      credit_transfers:
    }
  end
  let(:credit_transfers) do
    [{ counterparty_name: '1', counterparty_bic: 'b', counterparty_iban: 'iban', amount: '10', description: '1' }]
  end

  before { bank_account }

  describe 'POST' do
    context 'when payload is invalid' do
      it 'returns http created' do
        post '/transfers', params: {}

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'logs validation error' do
        expect(Rails.logger).to receive(:error).with(hash_including(message: 'Unable to create bank account transfers'))

        post '/transfers', params: {}
      end
    end

    it 'returns http created' do
      post '/transfers', params: params

      expect(response).to have_http_status(:created)
    end
  end
end
