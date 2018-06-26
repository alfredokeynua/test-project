#!/bin/bash

# Determine the current GIT branch name
# -------------------------------------------------------------
export GIT_BRANCH=`git symbolic-ref HEAD --short 2>/dev/null`
if [ "$GIT_BRANCH" == "" ] ; then
  GIT_BRANCH=`git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }'`
  export GIT_BRANCH=${GIT_BRANCH#remotes/origin/}
fi

# Determine some GIT attributes
# -------------------------------------------------------------
export GIT_MESSAGE=`git log -1 --pretty=%B`
export GIT_AUTHOR=`git log -1 --pretty=%an`
export GIT_AUTHOR_EMAIL=`git log -1 --pretty=%ae`
export GIT_COMMIT=`git log -1 --pretty=%H`
export GIT_COMMIT_SHORT=`git log -1 --pretty=%h`
export GIT_TAG=`git describe --tags --abbrev=0`

# Build a name that contains the Branch-Commit-(Tag)
# -------------------------------------------------------------
export BUILD_NAME="$GIT_COMMIT_SHORT-$GIT_BRANCH"
if [ -n "$GIT_TAG" ]; then
	export BUILD_NAME="$GIT_TAG-$BUILD_NAME"
fi

# Determine if it is a pull request
# -------------------------------------------------------------
export IS_PULL_REQUEST=false
if [[ $CODEBUILD_SOURCE_VERSION == pr/* ]] ; then
  export IS_PULL_REQUEST=true
  export PULL_REQUEST_ID=`echo $CODEBUILD_SOURCE_VERSION | tr / _`
  export BUILD_NAME="$BUILD_NAME-$PULL_REQUEST_ID"
fi

# Determine the deployable zip file name based on the branch
# -------------------------------------------------------------
export ZIP_FOR_DEV="dev.zip"
export ZIP_FOR_PROD="master.zip"
export ZIP_NAME=""
if [ "$GIT_BRANCH" == "dev" ] ; then
  export ZIP_NAME="dev.zip"
fi
if [ "$GIT_BRANCH" == "release-*" ] ; then
  export ZIP_NAME="master.zip"
fi
if [ "$GIT_BRANCH" == "master" ] ; then
  export ZIP_NAME="master.zip"
fi

# Clear the zip name when it is a pull request
# -------------------------------------------------------------
if [ "$IS_PULL_REQUEST" == "true" ] ; then
  export ZIP_NAME=""
fi

# Echo the export commands to include in the build-spec.yml
# -------------------------------------------------------------
# In the buildspec.yml run:
# - chmod +x ./code-build-extra.sh
# - ./code-build-extra.sh > temp.sh
# - . ./temp.sh
# - rm ./temp.sh
# - echo $GIT_NAME
# -------------------------------------------------------------
echo "export GIT_AUTHOR=\"$GIT_AUTHOR\""
echo "export GIT_AUTHOR_EMAIL=\"$GIT_AUTHOR_EMAIL\""
echo "export GIT_BRANCH=\"$GIT_BRANCH\""
echo "export GIT_COMMIT=\"$GIT_COMMIT\""
echo "export GIT_MESSAGE=\"$GIT_MESSAGE\""
echo "export GIT_TAG=\"$GIT_TAG\""
echo "export GIT_PULL_REQUEST=\"$IS_PULL_REQUEST\""
echo "export GIT_NAME=\"$BUILD_NAME\""
echo "export ZIP_NAME=\"$ZIP_NAME\""