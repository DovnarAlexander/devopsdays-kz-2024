#!/bin/bash

set -e -x

git checkout main
git pull
git checkout gh-pages
git push --force

gh release list --limit 500 \
  | cut -f3 \
  | while read release_tag; do
  gh release delete -y "$release_tag"
done

git fetch
git tag -l | xargs -n 1 git push --delete origin
git tag -l | xargs git tag -d

gh run list -L 300 --json databaseId  -q '.[].databaseId' | xargs -IID gh api \
    "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions/runs/ID" \
    -X DELETE --silent

git branch -D feature/add-library-chart
git branch -D feature/add-application-1
git branch -D feature/add-argo-cd
git branch -D feature/add-jenkins
