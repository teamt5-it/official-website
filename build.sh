#!/bin/bash

DIR=$( cd "$( dirname "$0" )" && pwd )
TARGET=${DIR}/.build

mkdir -p "${TARGET}"

bundle exec jekyll build -d _site

cp -R {_site,config,run-server,Procfile} "${TARGET}/"
