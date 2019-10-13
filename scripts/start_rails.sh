#!/bin/bash

rm -f tmp/pids/server.pid && bundle && rails db:migrate && bundle exec rails s -b 0.0.0.0
