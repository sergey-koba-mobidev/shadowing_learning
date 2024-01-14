class LearnController < ApplicationController
  def learn
    @phrase = Phrase.find(Phrase.where(disliked_at: nil).pluck(:id).sample)
  end
end
