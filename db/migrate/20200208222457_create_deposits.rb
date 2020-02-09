class CreateDeposits < ActiveRecord::Migration[6.0]
  def change
    create_table :deposits do |t|
      t.references :destination, null: false
      t.float :amount, null: false

      t.timestamps
    end
  end
end
