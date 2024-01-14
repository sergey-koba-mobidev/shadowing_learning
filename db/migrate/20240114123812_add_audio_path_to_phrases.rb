class AddAudioPathToPhrases < ActiveRecord::Migration[7.1]
  def change
    add_column :phrases, :audio_path, :string
  end
end
