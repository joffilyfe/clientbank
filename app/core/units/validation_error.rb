# frozen_string_literal: true

module Units
  class ValidationError < StandardError

    delegate :to_s, to: :to_h
    delegate :to_h, to: :errors

    def initialize(errors = {}) # rubocop:disable Lint/MissingSuper
      @errors = errors
    end

    attr_reader :errors

  end
end
