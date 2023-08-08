#!/bin/bash
set -e

rm -f /myapp/tmp/pids/server.pid

if [ $RAILS_ENV = 'production' ]; then
  bundle exec rails assets:clobber
  bundle exec rails assets:precompile
fi

bundle exec rails server -b '0.0.0.0' -p ${PORT:-3000}

# exec "$@"
