#!/bin/bash

git commit --amend -am "$(git show -s --pretty=%B HEAD)"
git push --force-with-lease 