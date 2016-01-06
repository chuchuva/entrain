class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.references :site
      t.references :program, index: true
      t.string :email_type
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
