#!/bin/sh
#Retrieve the pull request id related to the commit and set it as environment variable (used by danger)
export ghprbPullId=$(git ls-remote origin 'pull/*' | grep $(git rev-parse HEAD) | awk '{print $2}' | grep -Eo '([0-9]+)')
export GIT_URL=$(git config --get remote.origin.url)
bundle exec danger