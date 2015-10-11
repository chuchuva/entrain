class AddPriceToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :price, :decimal, precision: 15, scale: 2
  end
end
