class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :site, index: true
      t.references :program, index: true
      t.string :url
      t.string :file_name
      t.integer :size

      t.timestamps
    end
  end
end
