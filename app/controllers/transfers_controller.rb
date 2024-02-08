# frozen_string_literal: true

class TransfersController < ApplicationController

  rescue_from Units::ValidationError, with: :rescue_from_validation_error

  def create
    head :created if Units::CreateTransfer::EntryPoint.call(payload)
  end

  private

  def rescue_from_validation_error(error)
    Rails.logger.error(message: 'Unable to create bank account transfers', payload:, error:)

    head :unprocessable_entity
  end

  def payload
    params.to_h
  end

end
