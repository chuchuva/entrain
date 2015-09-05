class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :subdomain

      t.timestamps
    end
    add_reference :users, :site, index: true
    add_reference :invites, :site, index: true
  end
end
