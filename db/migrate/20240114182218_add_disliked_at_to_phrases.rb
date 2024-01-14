class AddDislikedAtToPhrases < ActiveRecord::Migration[7.1]
  def change
    add_column :phrases, :disliked_at, :timestamp
  end
end
