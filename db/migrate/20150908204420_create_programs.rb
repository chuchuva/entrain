class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.references :site, index: true
      t.string :name
      t.string :slug
      t.text :content

      t.timestamps
    end
  end
end
