class Phrase < ApplicationRecord
  belongs_to :audio

  validates :body, presence: true
end
