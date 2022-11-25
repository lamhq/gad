release_tag="v${npm_package_version}"
release_branch="release/${release_tag}"

# create release branch
git checkout -b ${release_branch}

# update version and changelog
yarn run standard-version --skip.tag

# push release branch
git push --set-upstream origin ${release_branch} --no-verify

echo "Release branch created. Please submit a pull request to merge it."