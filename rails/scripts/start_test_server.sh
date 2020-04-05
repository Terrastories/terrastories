#!/bin/bash

echo "running script"
rm -f tmp/pids/test_server.pid && bundle exec rails s -b 0.0.0.0 --pid tmp/pids/test_server.pid