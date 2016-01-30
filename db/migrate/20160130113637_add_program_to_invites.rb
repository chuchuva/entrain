class AddProgramToInvites < ActiveRecord::Migration
  def change
    add_reference :invites, :program, index: true
    add_column :invites, :first_name, :string
  end
end
