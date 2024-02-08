# frozen_string_literal: true

class BankAccount < ApplicationRecord

  monetize :balance_cents

end
