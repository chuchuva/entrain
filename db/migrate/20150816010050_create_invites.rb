class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :invite_key, null: false, limit: 32
      t.string :email, null: false
      t.integer :invited_by_id, null: false
      t.integer :user_id, null: true
      t.datetime :redeemed_at
      t.datetime :deleted_at
      t.integer :deleted_by_id

      t.timestamps
    end
  end
end
