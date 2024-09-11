#!/bin/bash

set -e -x

gh release list --limit 500 \
  | cut -f3 \
  | while read release_tag; do
  gh release delete -y "$release_tag"
done

git tag -l | xargs git tag -d
git fetch
git tag -l | xargs -n 1 git push --delete origin
