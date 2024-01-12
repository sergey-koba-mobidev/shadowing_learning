json.extract! phrase, :id, :body, :audio_file, :audio_id, :created_at, :updated_at
json.url phrase_url(phrase, format: :json)
json.audio_file url_for(phrase.audio_file)
