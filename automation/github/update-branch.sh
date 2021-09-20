#!/bin/bash

while (( "$#" )); do
  case "$1" in
    --URL)
      REMOTE_URL=$2
      shift 2
      ;;
    --USER)
      USER=$2
      shift 2
      ;;
    --FORCE)
      FORCE=$2
      shift 2
      ;;
    *)
      echo Unsupport argument $1
      exit 1
      ;;
  esac
done

git config --global user.name "${USER}"
git config --global user.email "${USER}@users.noreply.github.com"

git pull --unshallow

git remote add upstream ${REMOTE_URL}
git fetch upstream

git remote -v

git checkout main

if [[ $FORCE -eq 1 ]]; then
  git merge --strategy-option theirs --no-ff --no-edit upstream/main
else
  git merge --no-edit upstream/main
fi

DIFF=$(git diff --name-only HEAD@{0} HEAD@{1})

echo ::set-output name=files_diff::"${DIFF}"

if [[ $FORCE -eq 1 ]]; then
  git push upstream HEAD:main
else
  git push upstream main
fi
