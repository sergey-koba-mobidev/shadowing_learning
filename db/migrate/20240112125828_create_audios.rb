class CreateAudios < ActiveRecord::Migration[7.1]
  def change
    create_table :audios do |t|
      t.string :title
      t.text :description
      t.text :metadata

      t.timestamps
    end
  end
end
