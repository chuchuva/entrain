class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :site
      t.references :program, index: true
      t.string :slug, null: false
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
