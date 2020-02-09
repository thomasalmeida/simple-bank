class CreateWithdrawals < ActiveRecord::Migration[6.0]
  def change
    create_table :withdrawals do |t|
      t.references :source, null: false
      t.float :amount, null: false

      t.timestamps
    end
  end
end
