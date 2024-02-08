# frozen_string_literal: true

class Transfer < ApplicationRecord

  belongs_to :bank_account

  monetize :amount_cents

end
