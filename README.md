# README

## Local development

### Requirements

Heroku-cli
Postgres 9.5

### Setup

Rename `Procfile.dev.default` to `Procfile.dev`, and replace `ABSOLUTE_PATH_TO_PROJECT` with the absolute path to the project's folder.

Run the app with `heroku local -f Procfile.dev`

Use https://mailcatcher.me/ for emails in development mode. Simply run `gem install mailcatcher` then `mailcatcher` to get started.

### Recovering from resque worker buildup
Sometimes resque won't kill workers after restart, so from a worker count of 1 you end up with 2, using up all available RAM. Here's how to solve it:

```
heroku run rake resque:cleanup_stuck_workers -r production;
heroku run rake resque:cleanup_idle_workers -r production;
heroku restart -r production;
```