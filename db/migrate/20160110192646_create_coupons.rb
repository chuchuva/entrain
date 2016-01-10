class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.references :site
      t.references :program
      t.string :code
      t.decimal :price, precision: 15, scale: 2

      t.timestamps
    end

    add_index :coupons, [:program_id, :code], :unique => true
  end
end
