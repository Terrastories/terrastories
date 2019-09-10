#!/bin/bash

echo 'Running potential asset precompile'

if [ $# -eq 0 ] ; then
  echo 'no argument supplied, precompiling'
  RAILS_ENV=production rake assets:precompile
else
  if [ $1 == "not" ] ; then
    echo "argument == not, so not running precompile"
  else
    echo 'argument supplied but different from not, precompiling'
    RAILS_ENV=production rake assets:precompile
  fi
fi