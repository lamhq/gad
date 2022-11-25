# update version and changelog
standard-version --skip.tag

npm_package_version=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[", ]//g')
release_tag="v${npm_package_version}"
release_branch="release/${release_tag}"

# create release branch
git checkout -b ${release_branch}

# push release branch
git push --set-upstream origin ${release_branch} --no-verify

# revert changes in master
git branch --delete master
git fetch master

echo "Release branch created. Please submit a pull request to merge it."