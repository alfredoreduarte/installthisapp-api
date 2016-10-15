# README

## Local development

You'll need:

Heroku-cli
Postgres 9.5

Rename `Procfile.dev.default` to `Procfile.dev`, and replace `ABSOLUTE_PATH_TO_PROJECT` with the absolute path to the project's folder.

Run the app with `heroku local -f Procfile.dev`

Use https://mailcatcher.me/ for emails in development mode. Simply run `gem install mailcatcher` then `mailcatcher` to get started.