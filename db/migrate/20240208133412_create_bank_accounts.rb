class CreateBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_accounts do |t|
      t.string :organization_name, null: false
      t.string :iban, null: false
      t.string :bic, null: false
      t.monetize :balance

      t.timestamps
    end

    add_index :bank_accounts, [:iban, :bic], unique: true
  end
end
