class Audio < ApplicationRecord
  has_one_attached :audio_file

  validates :title, presence: true
  validates :audio_file, presence: true
end
