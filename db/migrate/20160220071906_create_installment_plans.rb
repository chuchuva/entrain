class CreateInstallmentPlans < ActiveRecord::Migration
  def change
    create_table :installment_plans do |t|
      t.references :site, index: true
      t.references :program, index: true
      t.decimal :first_payment
      t.text :description
      t.references :coupon

      t.timestamps
    end
    add_reference :orders, :installment_plan
  end
end
