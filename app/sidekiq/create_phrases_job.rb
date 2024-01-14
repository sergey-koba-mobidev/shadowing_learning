require "google/cloud/speech"

THRESHOLD = 20

class CreatePhrasesJob
  include Sidekiq::Job

  def perform(audio_id)
    audio = Audio.find(audio_id)

    audio.audio_file.open do |file|
      transcripts = JSON.parse(audio.metadata, symbolize_names: true)[:transcripts]
      transcripts.each do |transcript|
        next if transcript[:words].size > THRESHOLD

        phrase = Phrase.create(body: transcript[:transcript], audio: audio)

        start_time = transcript[:words].first[:start_time]
        duration = transcript[:words].last[:end_time] - start_time

        res = `sox #{file.path} public/audios/phrase_#{phrase.id}.wav trim #{start_time.round(1)} #{duration.round(1) + 0.2}`
        logger.info "--- `sox #{file.path} public/audios/phrase_#{phrase.id}.wav trim #{start_time.round(1)} #{duration.round(1) + 0.2}`"
        phrase.update(audio_path: "public/audios/phrase_#{phrase.id}.wav")
      end
    end
  end
end
