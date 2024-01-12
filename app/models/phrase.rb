class Phrase < ApplicationRecord
  belongs_to :audio
  has_one_attached :audio_file

  validates :title, presence: true
end
