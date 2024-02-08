class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.string :counterparty_name, null: false
      t.string :counterparty_iban, null: false
      t.string :counterparty_bic, null: false
      t.string :description, null: false
      t.monetize :amount
      t.references :bank_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
