# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Andreord::Application.config.secret_token = ENV['SECRET_TOKEN'] || '3e6f623ed52d28a629f8611bf1edec02a8e9d172ac3bb5b2145044a81e57575583ec27d2609bb61b882370034be24b81feddaeb3a7cb31cb253684fa5a21ade2'
