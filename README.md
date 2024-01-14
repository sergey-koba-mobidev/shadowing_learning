# Shadowing Learning

## Getting Started
- `copy .env.example .env`
- `docker compose run --rm web bin/rails db:prepare`
- [Setup Google speech to text](https://cloud.google.com/ruby/docs/reference/google-cloud-speech/latest) and place Service Account credentials to `config/credentials.json`

## Usage
- `docker compose up`
- `docker compose stop`
- *IMPORTANT:* input audios should be in WAV format, MONO channel, 16 kHz Sample Rate
