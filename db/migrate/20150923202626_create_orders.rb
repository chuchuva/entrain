class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :site
      t.references :program
      t.references :user
      t.string :first_name
      t.string :last_name
      t.string :email
      t.decimal :amount, precision: 15, scale: 2
      t.string :pay_method

      t.timestamps
    end
  end
end
