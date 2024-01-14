class LearnController < ApplicationController
  def learn
    @phrase = Phrase.find(Phrase.pluck(:id).sample)
  end
end
