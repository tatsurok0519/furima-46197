#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install --without development test
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:schema:load
bundle exec rake db:seed