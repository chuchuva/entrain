class CreateProgramModules < ActiveRecord::Migration
  def change
    create_table :program_modules do |t|
      t.references :site, index: true
      t.references :program, index: true
      t.string :title
      t.text :content
      t.string :video_url

      t.timestamps
    end
  end
end
