# frozen_string_literal: true

module Units
  module CreateTransfer
    class EntryPoint

      include Units::EntryPoint

      def initialize(payload)
        @inputs = Inputs.new.call(payload)
        @action = Action.new(@inputs)
      end

    end
  end
end
