#!/bin/bash

export CI=true
export CBUILD=true

export CBUILD_GIT_BRANCH=`git symbolic-ref HEAD --short 2>/dev/null`
if [ "$CBUILD_GIT_BRANCH" == "" ] ; then
  CBUILD_GIT_BRANCH=`git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }'`
  export CBUILD_GIT_BRANCH=${CBUILD_GIT_BRANCH#remotes/origin/}
fi

export CBUILD_GIT_MESSAGE=`git log -1 --pretty=%B`
export CBUILD_GIT_AUTHOR=`git log -1 --pretty=%an`
export CBUILD_GIT_AUTHOR_EMAIL=`git log -1 --pretty=%ae`
export CBUILD_GIT_COMMIT=`git log -1 --pretty=%H`
export CBUILD_GIT_TAG=`git describe --tags --abbrev=0`

export CBUILD_PULL_REQUEST=false
if [[ $CBUILD_GIT_BRANCH == pr-* ]] ; then
  export CBUILD_PULL_REQUEST=${CBUILD_GIT_BRANCH#pr-}
fi

export CBUILD_PROJECT=${CBUILD_BUILD_ID%:$CBUILD_LOG_PATH}
export CBUILD_BUILD_URL=https://$AWS_DEFAULT_REGION.console.aws.amazon.com/codebuild/home?region=$AWS_DEFAULT_REGION#/builds/$CBUILD_BUILD_ID/view/new

echo "==> AWS CodeBuild Extra Environment Variables:"
echo "==> CI = $CI"
echo "==> CBUILD = $CBUILD"
echo "==> CBUILD_GIT_AUTHOR = $CBUILD_GIT_AUTHOR"
echo "==> CBUILD_GIT_AUTHOR_EMAIL = $CBUILD_GIT_AUTHOR_EMAIL"
echo "==> CBUILD_GIT_BRANCH = $CBUILD_GIT_BRANCH "
echo "==> CBUILD_GIT_COMMIT = $CBUILD_GIT_COMMIT"
echo "==> CBUILD_GIT_MESSAGE = $CBUILD_GIT_MESSAGE"
echo "==> CBUILD_GIT_TAG = $CBUILD_GIT_TAG"
echo "==> CBUILD_PROJECT = $CBUILD_PROJECT"
echo "==> CBUILD_PULL_REQUEST = $CBUILD_PULL_REQUEST"