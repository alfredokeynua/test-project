#!/bin/bash

export CBUILD_GIT_BRANCH=`git symbolic-ref HEAD --short 2>/dev/null`
if [ "$CBUILD_GIT_BRANCH" == "" ] ; then
  CBUILD_GIT_BRANCH=`git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }'`
  export CBUILD_GIT_BRANCH=${CBUILD_GIT_BRANCH#remotes/origin/}
fi

export CBUILD_GIT_MESSAGE=`git log -1 --pretty=%B`
export CBUILD_GIT_AUTHOR=`git log -1 --pretty=%an`
export CBUILD_GIT_AUTHOR_EMAIL=`git log -1 --pretty=%ae`
export CBUILD_GIT_COMMIT=`git log -1 --pretty=%H`
export CBUILD_GIT_COMMIT_SHORT=`git log -1 --pretty=%h`
export CBUILD_GIT_TAG=`git describe --tags --abbrev=0`

export CBUILD_NAME="$CBUILD_GIT_BRANCH-$CBUILD_GIT_COMMIT_SHORT"
if [ -n "$CBUILD_GIT_TAG" ]; then
	export CBUILD_NAME="$CBUILD_NAME-$CBUILD_GIT_TAG"
fi

export CBUILD_IS_PULL_REQUEST=false
export CBUILD_PULL_REQUEST_BRANCH=""
if [[ $CODEBUILD_SOURCE_VERSION == pr/* ]] ; then
  export CBUILD_IS_PULL_REQUEST=true
  export CBUILD_PULL_REQUEST_BRANCH=${CBUILD_GIT_BRANCH#pr-}
  export CBUILD_PULL_REQUEST_ID=$CODEBUILD_SOURCE_VERSION | tr / _
  export CBUILD_NAME="$CBUILD_NAME-$CBUILD_PULL_REQUEST_ID"
fi

echo "==> AWS CodeBuild Extra Environment Variables:"
echo "==> CBUILD_GIT_AUTHOR = $CBUILD_GIT_AUTHOR"
echo "==> CBUILD_GIT_AUTHOR_EMAIL = $CBUILD_GIT_AUTHOR_EMAIL"
echo "==> CBUILD_GIT_BRANCH = $CBUILD_GIT_BRANCH "
echo "==> CBUILD_GIT_COMMIT = $CBUILD_GIT_COMMIT"
echo "==> CBUILD_GIT_MESSAGE = $CBUILD_GIT_MESSAGE"
echo "==> CBUILD_GIT_TAG = $CBUILD_GIT_TAG"
echo "==> CBUILD_IS_PULL_REQUEST = $CBUILD_IS_PULL_REQUEST"
echo "==> CBUILD_PULL_REQUEST_BRANCH = $CBUILD_PULL_REQUEST_BRANCH"
echo "==> CBUILD_NAME = $CBUILD_NAME"