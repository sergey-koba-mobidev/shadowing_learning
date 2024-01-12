json.extract! audio, :id, :title, :description, :metadata, :audio_file, :created_at, :updated_at
json.url audio_url(audio, format: :json)
json.audio_file url_for(audio.audio_file)
