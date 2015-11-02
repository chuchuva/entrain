class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.references :site
      t.references :program, index: true
      t.string :text_type
      t.text :value

      t.timestamps
    end
  end
end
