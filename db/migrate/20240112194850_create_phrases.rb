class CreatePhrases < ActiveRecord::Migration[7.1]
  def change
    create_table :phrases do |t|
      t.text :body
      t.references :audio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
