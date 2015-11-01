class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :password_set_at, :datetime, after: :password_set
    reversible do |dir|
      dir.up   { change_column_default :users, :password_set, false }
      dir.down { change_column_default :users, :password_set, true }
    end
  end
end
