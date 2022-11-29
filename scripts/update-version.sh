# update version and changelog
standard-version --skip.tag --skip.commit

npm_package_version=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[", ]//g')
release_branch="release/${npm_package_version}"

# create release branch
git checkout -b ${release_branch}

# push release branch
git add . && git commit -m "chore(release): ${npm_package_version}"
git push --set-upstream origin ${release_branch} --no-verify

# revert changes in master
git branch -D master
git fetch origin master

echo "Release branch created. Please submit a pull request to merge it."