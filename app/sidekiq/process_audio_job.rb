require "google/cloud/speech"

class ProcessAudioJob
  include Sidekiq::Job

  def perform(audio_id)
    audio = Audio.find(audio_id)

    client = ::Google::Cloud::Speech.speech do |config|
      config.credentials = "config/google/credentials.json"
    end

    config = {
      language_code: "pl-PL",
      enable_word_time_offsets: true,
      encoding: :LINEAR16,
      sample_rate_hertz: 16_000,
      enable_automatic_punctuation: true,
      use_enhanced: true,
      model: "latest_long"
    }

    audio_data = {
      uri: "gs://shadowing_learning/#{audio.audio_file.blob.key}"
    }

    logger.info "--- Start processing #{audio_data[:uri]}"

    operation = client.long_running_recognize config: config, audio: audio_data
    operation.wait_until_done!

    raise operation.results.message if operation.error?

    results = operation.response.results

    logger.info "--- Finished processing #{audio_data[:uri]}"

    result_hash = {
      transcripts: []
    }

    results.each do |result|
      alternative = result.alternatives.first
      alternative_hash = {
        words: []
      }
      alternative_hash[:transcript] = alternative.transcript
      logger.info "--- Transcription: #{alternative.transcript}. Alternatives count: #{result.alternatives.size}"
    
      alternative.words.each do |word|
        start_time = word.start_time.seconds + (word.start_time.nanos / 1_000_000_000.0)
        end_time   = word.end_time.seconds + (word.end_time.nanos / 1_000_000_000.0)
    
        logger.info "--- Word: #{word.word} #{start_time} #{end_time}"
        alternative_hash[:words] << {
          word: word.word,
          start_time: start_time,
          end_time: end_time
        }
      end
      result_hash[:transcripts] << alternative_hash
    end

    audio.update(metadata: result_hash.to_json)
    CreatePhrasesJob.perform_async(audio.id)
  end
end
