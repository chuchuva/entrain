class RemoveVideoUrlFromProgramModules < ActiveRecord::Migration
  def change
    remove_column :program_modules, :video_url, :string
  end
end
