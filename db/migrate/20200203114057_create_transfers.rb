class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.float :amount, null: false
      t.references :destination, null: false
      t.references :source, null: false

      t.timestamps
    end
  end
end
