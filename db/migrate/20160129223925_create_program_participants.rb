class CreateProgramParticipants < ActiveRecord::Migration
  def change
    create_table :program_participants do |t|
      t.references :site
      t.references :program
      t.references :user
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :program_participants, [:program_id, :user_id], unique: true
  end
end
