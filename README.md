# README

## Using rails engines
Use this branch to attempt to convert current 'modules' into rails engines.

Useful articles:

- http://guides.rubyonrails.org/engines.html
- https://pchm.co/posts/tutorial-how-to-build-a-cms-in-ruby-on-rails
- https://blog.pivotal.io/pivotal-labs/labs/leave-your-migrations-in-your-rails-engines
- http://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html
- https://www.toptal.com/ruby-on-rails/rails-engines-in-the-wild-real-world-examples-of-rails-engines-in-action

## Local development

You'll need foreman installed globally:

`gem install -g foreman`

Rename `Procfile.dev.default` to `Procfile.dev`, and replace `ABSOLUTE_PATH_TO_PROJECT` with the absolute path to the project's folder.

Use https://mailcatcher.me/ for emails in development mode. Simply run `gem install mailcatcher` then `mailcatcher` to get started.

