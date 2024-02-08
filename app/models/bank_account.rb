# frozen_string_literal: true

class BankAccount < ApplicationRecord

  has_many :transfers, dependent: :destroy

  monetize :balance_cents

end
