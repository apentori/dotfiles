#!/usr/bin/env bash


repos=$(yq -r '.[].src' $1)

for r in $repos; do
  echo "repo to clone $r "
  git clone $r
done
