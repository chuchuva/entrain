class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, limit: 255
      t.string :email, limit: 256, null: false
      t.string :password_digest, null: false
      t.string :auth_token, limit: 32
      t.inet :ip_address
      t.inet :registration_ip_address
      t.timestamps null: false

      t.index :auth_token, unique: true
    end
  end
end
